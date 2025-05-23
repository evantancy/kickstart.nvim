return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      require('fzf-lua').setup {
        winopts = { preview = { default = 'bat', layout = 'vertical', vertical = 'up:70%' } },
        -- specific picker options
        files = {
          cwd_prompt = true,
          cwd_prompt_shorten_len = 20, -- shorten prompt beyond this length
          cwd_prompt_shorten_val = 3, -- shortened path parts length
        },
      }

      vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = 'find References' })
      vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, { desc = 'find Implementation' })
      vim.keymap.set('n', 'gt', require('fzf-lua').lsp_typedefs, { desc = 'find Type Definition' })

      vim.keymap.set('n', '<leader>fz', '<cmd>FzfLua<CR>', { desc = 'FzfLua' })
      vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua<CR>', { desc = 'FzfLua' })
      vim.keymap.set('n', '<leader>fc', require('fzf-lua').command_history, { desc = 'Open command history in Fzf' })
      vim.keymap.set('n', '<leader>fb', require('fzf-lua').buffers, { desc = 'find buffers' })
      vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = 'find files' })
      vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep_resume, { desc = 'find grep' })

      -- vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_document_symbols, 'Search Document Symbols')
      vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_workspace_symbols, { desc = 'find Symbols' })

      -- vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, '[G]oto [S]ignature')

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
    end,
  },
}
