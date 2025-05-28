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
      -- use fzf-lua as a picker
      require('fzf-lua').register_ui_select()

      vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = 'find references' })
      vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = 'find definitions' })
      vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, { desc = 'find implementation' })
      vim.keymap.set('n', 'gt', require('fzf-lua').lsp_typedefs, { desc = 'find type definition' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })

      vim.keymap.set('n', '<leader>fz', '<cmd>FzfLua<CR>', { desc = 'FzfLua' })
      vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua<CR>', { desc = 'FzfLua' })
      vim.keymap.set('n', '<leader>fc', require('fzf-lua').command_history, { desc = 'Open command history in Fzf' })
      vim.keymap.set('n', '<leader>fb', require('fzf-lua').buffers, { desc = 'find buffers' })
      vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = 'find files' })
      vim.keymap.set('n', '<leader>fr', require('fzf-lua').resume, { desc = 'find resume' })
      vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'find grep' })
      vim.keymap.set('n', '<leader>f.', function()
        require('fzf-lua').oldfiles { cwd = vim.uv.cwd() }
      end, { desc = 'find recent files' })

      vim.keymap.set('n', '<leader>vrc', function()
        require('fzf-lua').files {
          prompt = '< VimRC Find Files >',
          cwd = '$DOTFILES',
          -- hidden = true,
        }
      end, { desc = 'VimRC Find Files' })

      vim.keymap.set('n', '<leader>vrg', function()
        require('fzf-lua').live_grep {
          prompt = '< VimRC Live Grep >',
          cwd = '$DOTFILES',
        }
      end, { desc = 'VimRC Live Grep' })

      -- vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_document_symbols, 'Search Document Symbols')
      vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_workspace_symbols, { desc = 'find Symbols' })

      -- vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, '[G]oto [S]ignature')

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
    end,
  },
}
