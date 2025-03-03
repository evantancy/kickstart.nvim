-- Youkuj can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Visualize undo trees
    'mbbill/undotree',
  },

  {
    'chrisgrieser/nvim-puppeteer',
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
  {
    'ggandor/leap.nvim',
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      local leap = require 'leap'
      vim.keymap.set({ 'n', 'x' }, 'gs', '<Plug>(leap)')
      vim.keymap.set('o', 'gs', '<Plug>(leap-forward)')
      -- vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
      -- vim.keymap.set('o', 'S', '<Plug>(leap-backward)')
    end,
    opts = {
      case_insensitive_regex = true,
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right | horizontal | vertical
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = '<tab>',
            accept_word = false,
            accept_line = false,
            next = '<C-n>',
            prev = '<C-p>',
            -- dismiss = '<C-c>',
            dismiss = '<esc>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
  },
  { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons', opts = {} },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    dependencies = {
      'ibhagwan/fzf-lua',
      -- optional for icon support
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        -- calling `setup` is optional for customization
        require('fzf-lua').setup {}
      end,
    },
    keys = {
      {
        '<leader>tt',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = '[T]rouble Diagnostics',
      },
      {
        '<leader>tT',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = '[T]rouble Buffer Diagnostics',
      },
      {
        '<leader>ts',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = '[T]rouble Symbols',
      },
      -- TODO: Configure these
      {
        '<leader>tl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>l',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>qf',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    -- Harpoon
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon.setup {}
      --
      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'harpoon [a]dd' })
      -- vim.keymap.set('n', '<leader>hl', function()
      --   harpoon.ui:toggle_quick_menu(harpoon:list())
      -- end, { desc = '[h]arpoon [l]ist' })
      vim.keymap.set('n', '<A-1>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<A-2>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<A-3>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<A-4>', function()
        harpoon:list():select(4)
      end)
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<A-p>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<A-n>', function()
        harpoon:list():next()
      end)
    end,
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      -- default configuration
      require('illuminate').configure {
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        -- delay: delay in milliseconds
        delay = 100,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'fugitive',
        },
        -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
        -- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
        filetypes_allowlist = {},
        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
        -- See `:help mode()` for possible values
        modes_denylist = {},
        -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
        -- See `:help mode()` for possible values
        modes_allowlist = {},
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_allowlist = {},
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = true,
        -- large_file_cutoff: number of lines at which to use large_file_config
        -- The `under_cursor` option is disabled when this cutoff is hit
        large_file_cutoff = nil,
        -- large_file_config: config to use for large files (based on large_file_cutoff).
        -- Supports the same keys passed to .configure
        -- If nil, vim-illuminate will be disabled for large files.
        large_file_overrides = nil,
        -- min_count_to_highlight: minimum number of matches required to perform highlighting
        min_count_to_highlight = 1,
        -- should_enable: a callback that overrides all other settings to
        -- enable/disable illumination. This will be called a lot so don't do
        -- anything expensive in it.
        should_enable = function(bufnr)
          return true
        end,
        -- case_insensitive_regex: sets regex case sensitivity
        case_insensitive_regex = false,
      }
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          insert = '<C-g>s',
          insert_line = '<C-g>S',
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
          change_line = 'cS',
        },
        aliases = {
          ['a'] = '>',
          ['b'] = ')',
          ['B'] = '}',
          ['r'] = ']',
          ['q'] = { '"', "'", '`' },
          ['s'] = { '}', ']', ')', '>', '"', "'", '`' },
        },
        highlight = {
          duration = 500,
        },
      }
    end,
  },
}
