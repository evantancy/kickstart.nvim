vim.lsp.inlay_hint.enable(true)
vim.g.inlay_hints_visible = true

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

-- toggle diagnostics for current buffer
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = '[T]oggle [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Goto prev [d]iagnostic' })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Goto next [d]iagnostic' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Goto previous error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Goto next error' })

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  {
    -- Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
    -- NOTE: this is the only plugin that works well for python
    -- tried vim-doge and neogen as well
    'heavenshell/vim-pydocstring',
    build = 'make install',
    config = function()
      vim.g.pydocstring_formatter = 'google' -- 'google', 'numpy', 'sphinx'
      vim.cmd [[nmap <silent> <leader>dg <Plug>(pydocstring)]]
      vim.keymap.set('n', '<leader>dg', '<Plug>(pydocstring)', { desc = 'docstring generate' })
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- 'nvim-telescope/telescope.nvim',
    },
    lazy = false,
    config = function()
      local refactoring = require 'refactoring'
      refactoring.setup()
      vim.keymap.set({ 'n', 'x' }, '<leader>rr', refactoring.select_refactor, { desc = 'Toggle [R]efactoring menu' })
      vim.keymap.set({ 'n', 'x' }, '<leader>re', function()
        return require('refactoring').refactor 'Extract Function'
      end, { expr = true, desc = 'Extract Function' })
      vim.keymap.set({ 'n', 'x' }, '<leader>rf', function()
        return require('refactoring').refactor 'Extract Function To File'
      end, { expr = true, desc = 'Extract Function To File' })
      vim.keymap.set({ 'n', 'x' }, '<leader>rv', function()
        return require('refactoring').refactor 'Extract Variable'
      end, { expr = true, desc = 'Extract Variable' })
      vim.keymap.set({ 'n', 'x' }, '<leader>rI', function()
        return require('refactoring').refactor 'Inline Function'
      end, { expr = true, desc = 'Inline Function' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', function()
        return require('refactoring').refactor 'Inline Variable'
      end, { expr = true, desc = 'Inline Variable' })

      vim.keymap.set({ 'n', 'x' }, '<leader>rbb', function()
        return require('refactoring').refactor 'Extract Block'
      end, { expr = true, desc = 'Extract Block' })
      vim.keymap.set({ 'n', 'x' }, '<leader>rbf', function()
        return require('refactoring').refactor 'Extract Block To File'
      end, { expr = true, desc = 'Extract Block To File' })

      -- NOTE: for some reason telescope ext not working
      -- require('telescope').load_extension 'refactoring'
      -- vim.keymap.set({ 'n', 'x' }, '<leader>rr', require('telescope').extensions.refactoring.refactors, { desc = 'Toggle [R]efactoring menu' })
    end,
  },
}
