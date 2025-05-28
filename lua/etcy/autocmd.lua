-- autoformatting
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

local function merge_opts(opts, extra)
  return vim.tbl_extend('force', opts or {}, extra or {})
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    -- Diagnostic navigation keymaps
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', merge_opts(opts, { desc = 'Goto prev diagnostic' }))
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', merge_opts(opts, { desc = 'Goto next diagnostic' }))
    vim.keymap.set('n', '[e', function()
      vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
    end, merge_opts(opts, { desc = 'Goto previous error' }))
    vim.keymap.set('n', ']e', function()
      vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
    end, merge_opts(opts, { desc = 'Goto next error' }))
    vim.keymap.set('n', '[w', function()
      vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
    end, merge_opts(opts, { desc = 'Goto previous warning' }))
    vim.keymap.set('n', ']w', function()
      vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
    end, merge_opts(opts, { desc = 'Goto next warning' }))
  end,
})
