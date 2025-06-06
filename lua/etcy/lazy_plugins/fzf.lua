return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function()
      local actions = require('fzf-lua').actions
      require('fzf-lua').setup {
        { 'telescope', 'fzf-native' },

        winopts = { preview = { default = 'bat', layout = 'vertical', vertical = 'up:70%' } },
        -- specific picker options
        files = {
          cwd_prompt = true,
          cwd_prompt_shorten_len = 20, -- shorten prompt beyond this length
          cwd_prompt_shorten_val = 3, -- shortened path parts length
        },
        actions = {
          -- Below are the default actions, setting any value in these tables will override
          -- the defaults, to inherit from the defaults change [1] from `false` to `true`
          files = {
            -- true,        -- uncomment to inherit all the below in your custom config
            -- Pickers inheriting these actions:
            --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
            --   tags, btags, args, buffers, tabs, lines, blines
            -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
            -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
            -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
            ['enter'] = actions.file_edit_or_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
            ['alt-Q'] = actions.file_sel_to_ll,
            ['alt-i'] = actions.toggle_ignore,
            ['alt-h'] = actions.toggle_hidden,
            ['alt-f'] = actions.toggle_follow,
          },
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
      vim.keymap.set('n', '<leader>fG', require('fzf-lua').live_grep, { desc = 'find grep' })
      vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep_glob, { desc = 'find grep with glob opts' })
      vim.keymap.set('n', '<leader>fw', function()
        require('fzf-lua').grep { search = vim.fn.expand '<cword>' }
      end, { desc = 'find grep current word' })
      vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { desc = 'current buffer fuzzy' })

      vim.keymap.set('n', '<leader>f.', function()
        require('fzf-lua').oldfiles { cwd = vim.uv.cwd() }
      end, { desc = 'find recent files' })

      vim.keymap.set('n', '<leader>vrc', function()
        require('fzf-lua').files {
          prompt = '< VimRC Find Files >',
          cwd = '$DOTFILES',
          hidden = true,
        }
      end, { desc = 'VimRC Find Files' })

      vim.keymap.set('n', '<leader>vrg', function()
        require('fzf-lua').live_grep {
          prompt = '< VimRC Live Grep >',
          cwd = '$DOTFILES',
          hidden = true,
        }
      end, { desc = 'VimRC Live Grep' })
    end,
  },
}
