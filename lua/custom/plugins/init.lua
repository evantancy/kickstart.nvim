-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
    'stevearc/oil.nvim',
    -- Optional dependencies
    -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      -- Oil keymaps
      vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })

      require('oil').setup {

        lsp_file_methods = {
          -- Enable or disable LSP file operations
          enabled = true,
          -- Time to wait for LSP file operations to complete before skipping
          timeout_ms = 10000,
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = true,
        },
        skip_confirm_for_simple_edits = true,
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,

        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
          -- NOTE: these are the defaults
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = { 'actions.close', mode = 'n' },
          ['<C-l>'] = 'actions.refresh',
          ['-'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },

          -- NOTE: user defined keybinds
          ['<C-y>'] = 'actions.select',
        },
      }
    end,
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
    'luukvbaal/statuscol.nvim',
    config = function()
      -- local builtin = require("statuscol.builtin")
      require('statuscol').setup {
        -- configuration goes here, for example:
        -- relculright = true,
        -- segments = {
        --   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        --   {
        --     sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
        --     click = "v:lua.ScSa"
        --   },
        --   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
        --   {
        --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        --     click = "v:lua.ScSa"
        --   },
        -- }
      }
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

  {
    'vyfor/cord.nvim',
    enabled = false,
    config = function()
      local quotes = {
        'GTA VI came out before my Rust program finished compiling. ⏳',
        'When your code works on the first try. 😱',
        'It’s not a bug, it’s a feature. 🐛✨',
        'I don’t always test my code, but when I do, I do it in production. 💥',
        'My code works, I have no idea why. 🤷‍♂️',
        'Hello from the other side... of a merge conflict. 🔀',
        'If it works, don’t touch it. 🛑',
        'May your code never compile on the first try. 🤞',
      }
      require('cord').setup {
        enabled = true,
        log_level = vim.log.levels.OFF,
        editor = {
          client = 'neovim',
          tooltip = 'Entering monk mode',
          icon = require('cord.api.icon').get 'shinto_shrine',
        },
        display = {
          theme = 'default',
          flavor = 'dark',
          swap_fields = false,
          swap_icons = false,
        },
        timestamp = {
          enabled = true,
          reset_on_idle = false,
          reset_on_change = false,
        },
        idle = {
          enabled = false,
          timeout = 300000,
          show_status = true,
          ignore_focus = true,
          unidle_on_focus = true,
          smart_idle = false,
          details = 'Idling',
          state = nil,
          tooltip = '💤',
          icon = nil,
        },
        text = {
          workspace = function(opts)
            return 'In ' .. opts.workspace
          end,
          viewing = function(opts)
            return 'Viewing ' .. opts.filename
          end,
          editing = function(opts)
            return 'Editing ' .. opts.filename
          end,
          file_browser = function(opts)
            return 'Browsing files in ' .. opts.name
          end,
          plugin_manager = function(opts)
            return 'Managing plugins in ' .. opts.name
          end,
          lsp = function(opts)
            return 'Configuring LSP in ' .. opts.name
          end,
          docs = function(opts)
            return 'Reading ' .. opts.name
          end,
          vcs = function(opts)
            return 'Committing changes in ' .. opts.name
          end,
          notes = function(opts)
            return 'Taking notes in ' .. opts.name
          end,
          debug = function(opts)
            return 'Debugging in ' .. opts.name
          end,
          test = function(opts)
            return 'Testing in ' .. opts.name
          end,
          diagnostics = function(opts)
            return 'Fixing problems in ' .. opts.name
          end,
          games = function(opts)
            return 'Playing ' .. opts.name
          end,
          terminal = function(opts)
            return 'Running commands in ' .. opts.name
          end,
          dashboard = 'Home',
        },
        -- buttons = nil,
        buttons = {
          {
            label = 'View Repository',
            url = function(opts)
              return opts.repo_url
            end,
          },
        },
        assets = nil,
        variables = nil,
        hooks = {
          ready = nil,
          shutdown = nil,
          pre_activity = nil,
          post_activity = function(_, activity)
            activity.details = quotes[math.random(#quotes)]
          end,
          idle_enter = nil,
          idle_leave = nil,
          workspace_change = nil,
        },
        plugins = nil,
        advanced = {
          plugin = {
            autocmds = true,
            cursor_update = 'on_hold',
            match_in_mappings = true,
          },
          server = {
            update = 'fetch',
            pipe_path = nil,
            executable_path = nil,
            timeout = 300000,
          },
          discord = {
            reconnect = {
              enabled = false,
              interval = 5000,
              initial = true,
            },
          },
        },
      }
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = {
          ours = 'co',
          theirs = 'ct',
          none = 'c0',
          both = 'cb',
          prev = '[x',
          next = ']x',
        },
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      }
    end,
  },

  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },

  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = 'openrouter',
      vendors = {
        openrouter = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          api_key_name = 'OPENROUTER_API_KEY',
          model = 'anthropic/claude-3.7-sonnet',
          -- NOTE: see https://github.com/yetone/avante.nvim/issues/1188
          -- model = 'deepseek/deepseek-r1:free',
          -- disable_tools = true,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    enabled = false,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          opts = {
            show_defaults = true,
          },
          openrouter_claude = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                url = 'https://openrouter.ai/api',
                api_key = 'cmd: EDITOR=cat sops -d ~/.openrouter-api-key.enc 2>/dev/null',
                chat_url = '/v1/chat/completions',
              },
              schema = {
                model = {
                  default = 'anthropic/claude-3.7-sonnet',
                },
              },
            })
          end,
        },
      }
    end,
  },

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
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
    dependencies = 'zbirenbaum/copilot.lua',
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
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
          hide_during_completion = false,
          debounce = 25,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = '<tab>',
            next = false,
            prev = false,
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

      vim.keymap.set('n', '<leader>tc', function()
        require('copilot.suggestion').toggle_auto_trigger()
      end, { desc = '[T]oggle [C]opilot' })
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

      -- vim.keymap.set('n', '<C-e>', function()
      --   toggle_telescope(harpoon:list())
      -- end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'harpoon [a]ppend' })
      -- vim.keymap.set('n', '<leader>A', function()
      --   harpoon:list():prepend()
      -- end, { desc = 'harpoon prepend' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[h]arpoon [l]ist' })
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
    enabled = false,
    config = function()
      vim.cmd [[ hi def IlluminatedWordText gui=underline cterm=underline ]]
      vim.cmd [[ hi def IlluminatedWordRead gui=underline cterm=underline ]]
      vim.cmd [[ hi def IlluminatedWordWrite gui=underline cterm=underline ]]
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
          'TelescopePrompt',
          'Avante',
          'codecompanion',
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

  -- {
  --   'kylechui/nvim-surround',
  --   version = '*', -- Use for stability; omit to use `main` branch for the latest features
  --   event = 'VeryLazy',
  --   config = function()
  --     require('nvim-surround').setup {
  --       -- Configuration here, or leave empty to use defaults
  --       keymaps = {
  --         insert = '<C-g>s',
  --         insert_line = '<C-g>S',
  --         normal = 'ys',
  --         normal_cur = 'yss',
  --         normal_line = 'yS',
  --         normal_cur_line = 'ySS',
  --         visual = 'S',
  --         visual_line = 'gS',
  --         delete = 'ds',
  --         change = 'cs',
  --         change_line = 'cS',
  --       },
  --       aliases = {
  --         ['a'] = '>',
  --         ['b'] = ')',
  --         ['B'] = '}',
  --         ['r'] = ']',
  --         ['q'] = { '"', "'", '`' },
  --         ['s'] = { '}', ']', ')', '>', '"', "'", '`' },
  --       },
  --       highlight = {
  --         duration = 1000,
  --       },
  --     }
  --   end,
  -- },
}
