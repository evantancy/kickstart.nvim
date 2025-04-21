return {
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 25,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
  },

  {
    'ruifm/gitlinker.nvim',
    config = function()
      require('gitlinker').setup {
        opts = {
          remote = nil, -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require('gitlinker.actions').copy_to_clipboard,
          -- print the url after performing the action
          print_url = true,
        },
        callbacks = {
          ['github.com'] = require('gitlinker.hosts').get_github_type_url,
          ['gh-work1'] = require('gitlinker.hosts').get_github_type_url,
          ['gh-work2'] = require('gitlinker.hosts').get_github_type_url,
          ['gh-work3'] = require('gitlinker.hosts').get_github_type_url,
          ['gitlab.com'] = require('gitlinker.hosts').get_gitlab_type_url,
          ['try.gitea.io'] = require('gitlinker.hosts').get_gitea_type_url,
          ['codeberg.org'] = require('gitlinker.hosts').get_gitea_type_url,
          ['bitbucket.org'] = require('gitlinker.hosts').get_bitbucket_type_url,
          ['try.gogs.io'] = require('gitlinker.hosts').get_gogs_type_url,
          ['git.sr.ht'] = require('gitlinker.hosts').get_srht_type_url,
          ['git.launchpad.net'] = require('gitlinker.hosts').get_launchpad_type_url,
          ['repo.or.cz'] = require('gitlinker.hosts').get_repoorcz_type_url,
          ['git.kernel.org'] = require('gitlinker.hosts').get_cgit_type_url,
          ['git.savannah.gnu.org'] = require('gitlinker.hosts').get_cgit_type_url,
        },
        -- default mapping to call url generation with action_callback
        mappings = '<leader>gh',
      }
    end,
  },

  {
    'sindrets/diffview.nvim',
    enabled = true,
    config = function()
      -- local actions = require 'diffview.actions'
      require('diffview').setup {}
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    enabled = false,
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = true,
        -- default_mappings = {
        --   ours = 'co',
        --   theirs = 'ct',
        --   none = 'c0',
        --   both = 'cb',
        --   prev = '[x',
        --   next = ']x',
        -- },
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
      }

      -- vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)')
      -- vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)')
      -- vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)')
      -- vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)')
      -- vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
      -- vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')

      -- when dealing with conflicts, disable diagnostics
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function(event)
          -- Get the buffer number from the event
          local bufnr = event.buf

          -- -- Set buffer-local mappings
          -- vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { buffer = bufnr })
          -- vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { buffer = bufnr })
          -- vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { buffer = bufnr })
          -- vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { buffer = bufnr })
          -- vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)', { buffer = bufnr })
          -- vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)', { buffer = bufnr })

          vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>' .. '. Use co/ct/cb/c0 to resolve.')
        end,
      })
      -- when dealing with conflicts, disable diagnostics
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictResolved',
        callback = function()
          vim.notify 'All conflicts resolved! 🎉'
        end,
      })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
