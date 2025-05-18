-- NOTE: define a common function to be used easily
function none_ls_setup()
  require('mason').setup()
  require('mason-null-ls').setup {
    -- use to auto install tools
    ensure_installed = {
      'stylua',
      'jq',
      'pyright',
      'ruff',
      'gopls',
      'gofumpt',
    },
    automatic_installation = true,
    handlers = {},
  }

  local none_ls = require 'null-ls'

  -- use none-ls for linter & diagnostics
  none_ls.setup {
    sources = {
      none_ls.builtins.formatting.stylua,
      none_ls.builtins.completion.spell,
      -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
    },
  }
end

vim.keymap.set('n', '<leader>f', function()
  require('conform').format { bufnr = 0 }
end)

return {
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
    config = function()
      none_ls_setup()
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function(_, opts)
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          -- Conform will run multiple formatters sequentially
          python = { 'isort', 'black' },
          python = { 'ruff_fix', 'ruff_format' },
          prisma = { 'prismals' },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
        },
      }
    end,
  },
}
