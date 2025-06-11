vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    -- explicitly enable c and r
    -- for <r> Pressing Enter will continue comments
    vim.opt_local.formatoptions:append 'cr'
    -- explicitly disable <o>, so <o> and <O> don't continue comments
    vim.opt_local.formatoptions:remove 'o'
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 150 }
  end,
})

-- Auto-reload files changed outside vim
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- TODO: verify this works
-- -- Refresh diagnostics when file changes
-- vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
--   pattern = '*',
--   callback = function()
--     vim.diagnostic.refresh()
--   end,
-- })

-- disable blink.cmp for these filetypes via an autocmd
vim.api.nvim_create_autocmd('FileType', {
  pattern = _G.custom_ignore_filetypes,
  callback = function()
    vim.b.completion = false
  end,
})

-- autoformatting
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }

    vim.cmd [[%s/\s\+$//e]]
  end,
})

local function merge_opts(opts, extra)
  return vim.tbl_extend('force', opts or {}, extra or {})
end

vim.api.nvim_create_autocmd('LspAttach', {
  -- stylua: ignore
  callback = function(e)
    local opts = { buffer = e.buf }
    -- navigation keymaps
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', merge_opts(opts, { desc = 'Goto prev diagnostic' }))
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', merge_opts(opts, { desc = 'Goto next diagnostic' }))
    vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, merge_opts(opts, { desc = 'Goto previous error' }))
    vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, merge_opts(opts, { desc = 'Goto next error' }))
    vim.keymap.set('n', '[w', function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN } end, merge_opts(opts, { desc = 'Goto previous warning' }))
    vim.keymap.set('n', ']w', function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN } end, merge_opts(opts, { desc = 'Goto next warning' }))
    -- NOTE: not sure if we should specify `wrap` param
    vim.keymap.set('n', ']r', function() require('illuminate').goto_next_reference() end, merge_opts(opts, { desc = 'go to next reference under cursor' }))
    vim.keymap.set('n', '[r', function() require('illuminate').goto_prev_reference() end, merge_opts(opts, { desc = 'go to next reference under cursor' }))

    -- LSP keymaps
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)

    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = 'find references' })
    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = 'find definitions' })
    vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, { desc = 'find implementation' })
    vim.keymap.set('n', 'gt', require('fzf-lua').lsp_typedefs, { desc = 'find type definition' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
    -- vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_document_symbols, 'Search Document Symbols')
    vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_live_workspace_symbols, { desc = 'find Symbols' })

    -- vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, '[G]oto [S]ignature')
    -- vim.keymap.set('i', '<C-h>', function()
    --   vim.lsp.buf.signature_help()
    -- end, { desc = 'signature help' })

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
  end,
})
