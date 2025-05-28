return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      require('fzf-lua').setup {
        { 'telescope', 'fzf-native' },

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
    end,
  },
}
