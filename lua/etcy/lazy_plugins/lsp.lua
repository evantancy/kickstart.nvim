-- NOTE: define a common function to be used easily
-- uses mason-null-ls to install tools
-- uses none-ls to lint & provide diagnostics (TODO: provide code actions)
-- uses conform to auto format
-- use nvim-lspconfig for enabling LSP features

local function none_ls_setup()
  require('mason').setup()
  require('mason-null-ls').setup {
    -- use to auto install tools
    ensure_installed = {
      'stylua',
      'jq',
      'ruff',
      'gopls',
      'gofumpt',
      -- 'mypy',
      'shfmt',
      'shellcheck',
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
      -- none_ls.builtins.diagnostics.mypy,
      none_ls.builtins.formatting.shfmt,
      none_ls.builtins.code_actions.refactoring,

      -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
    },
  }
end

vim.keymap.set('n', '<leader>fm', function()
  require('conform').format { bufnr = 0 }
end, { desc = 'conform format' })

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
}

-- toggle diagnostics for current buffer
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = '[T]oggle [D]iagnostics' })

return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    opts = {},
  },

  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mason-org/mason.nvim',
      'nvimtools/none-ls.nvim',
      'ThePrimeagen/refactoring.nvim',
    },
    config = function()
      none_ls_setup()
    end,
  },

  {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          -- Conform will run multiple formatters sequentially
          python = { 'ruff_fix', 'ruff_format' },
          prisma = { 'prismals' },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          zsh = { 'shfmt' },
          bash = { 'shfmt' },
          sh = { 'shfmt' },
        },
      }
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'mason-org/mason-lspconfig.nvim',
    version = 'v1.x',
    opts = {},
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
      { 'saghen/blink.cmp' },
      {
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = 'make install_jsregexp',
      },
      -- 'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-buffer',
      -- 'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
      -- 'hrsh7th/nvim-cmp',
      -- 'lukas-reineke/cmp-under-comparator',
      -- 'saadparwaiz1/cmp_luasnip',
      -- 'ray-x/lsp_signature.nvim',

      'onsails/lspkind.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    ---@diagnostic disable-next-line: unused-local
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      require('mason-lspconfig').setup {
        automatic_installation = true,
        ensure_installed = {
          'lua_ls',
          'gopls',
          'pyright',
          -- 'pylsp',
          -- 'sourcery',
          'ts_ls',
          'bashls',
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require('lspconfig')[server_name].setup {}
          end,
          -- Next, you can provide targeted overrides for specific servers.
          -- ['rust_analyzer'] = function()
          --   require('rust-tools').setup {}
          -- end,
          ['lua_ls'] = function()
            -- NOTE: override as needed and provide as arg
            local capabilities = {
              textDocument = {
                foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true,
                },
              },
            }
            lspconfig.lua_ls.setup {
              capabilities = require('blink.cmp').get_lsp_capabilities(),
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' },
                  },
                  format = {
                    enable = true,
                    defaultConfig = {
                      indent_style = 'space',
                      indent_size = '2',
                    },
                  },
                },
              },
            }
          end,
          ['bashls'] = function()
            lspconfig.bashls.setup {}
          end,

          -- ['pylsp'] = function()
          --   lspconfig.pylsp.setup {
          --     capabilities = false,
          --     settings = {
          --       pylsp = {
          --         enable = true,
          --         configurationSources = { 'ruff' },
          --         plugins = {
          --           jedi_rename = { enabled = false },
          --           rope_rename = { enabled = false },
          --           pylsp_rope = { enabled = true },
          --         },
          --       },
          --     },
          --   }
          -- end,

          ['pyright'] = function()
            -- NOTE: override as needed and provide as arg
            local capabilities = {
              textDocument = {
                foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true,
                },
              },
            }

            lspconfig.pyright.setup {
              capabilities = require('blink.cmp').get_lsp_capabilities(),
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = 'workspace',
                    useLibraryCodeForTypes = true,
                    autoImportCompletions = true,
                    typeCheckingMode = 'strict',
                  },
                },
              },
            }
          end,
        },
      }

      -- -- now configure lsp signature
      -- require('lsp_signature').setup {}

      -- local cmp = require 'cmp'
      -- local lspkind = require 'lspkind'
      -- require('cmp').setup {
      --   window = {
      --     completion = cmp.config.window.bordered(),
      --     documentation = cmp.config.window.bordered(),
      --   },
      --   mapping = cmp.mapping.preset.insert {
      --     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      --     ['<C-f>'] = cmp.mapping.scroll_docs(4),
      --     ['<C-Space>'] = cmp.mapping.complete(),
      --     ['<C-c>'] = cmp.mapping.abort(),
      --     ['<esc>'] = cmp.mapping.abort(),
      --     -- ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      --     ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      --     ['<C-j>'] = cmp.mapping.select_next_item(),
      --     ['<C-k>'] = cmp.mapping.select_prev_item(),
      --   },
      --   sources = cmp.config.sources {
      --     { name = 'lazydev', group_index = 0 },
      --     { name = 'nvim_lsp' },
      --     { name = 'luasnip' },
      --     { name = 'buffer' },
      --     { name = 'path' },
      --   },
      --   ---@diagnostic disable-next-line: missing-fields
      --   performance = {
      --     max_view_entries = 10,
      --     debounce = 25,
      --   },
      --   formatting = {
      --     format = lspkind.cmp_format {
      --       -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      --       -- can also be a function to dynamically calculate max width such as
      --       -- mode = 'symbol',
      --       -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      --       maxwidth = function()
      --         return math.floor(0.45 * vim.o.columns)
      --       end,
      --       ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      --       show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      --       -- The function below will be called before any actual modifications from lspkind
      --       -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --       -- before = function(entry, vim_item)
      --       --   return vim_item
      --       -- end,
      --       -- The function below will be called before any actual modifications from lspkind
      --       -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --       before = function(entry, item)
      --         local source_mapping = {
      --           buffer = '[Buf]',
      --           nvim_lsp = '[LSP]',
      --           copilot = ' [Copilot]',
      --           nvim_lua = '[Lua]',
      --           cmp_tabnine = '[TN]',
      --           path = '[Path]',
      --           luasnip = '[snip]',
      --         }
      --
      --         item.menu = source_mapping[entry.source.name]
      --         return item
      --       end,
      --     },
      --   },
      --   ---@diagnostic disable-next-line: missing-fields
      --   sorting = {
      --     comparators = {
      --       cmp.config.compare.offset,
      --       cmp.config.compare.exact,
      --       cmp.config.compare.score,
      --       require('cmp-under-comparator').under,
      --       cmp.config.compare.kind,
      --       cmp.config.compare.sort_text,
      --       cmp.config.compare.length,
      --       cmp.config.compare.order,
      --     },
      --   },
      -- }
    end,
  },

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'folke/lazydev.nvim' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = 'default',

        ['<C-y>'] = { 'select_and_accept' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        -- disable a keymap from the preset
        ['<CR>'] = {},
        ['<C-e>'] = {},
        ['<Up>'] = {},
        ['<Down>'] = {},

        -- show with a list of providers
        ['<C-space>'] = {
          function(cmp)
            cmp.show { providers = { 'snippets' } }
          end,
        },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        -- documentation = { auto_show = true, auto_show_delay_ms = 300, treesitter_highlighting = false },
        documentation = { auto_show = true },
        list = {
          max_items = 30,
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = true,
            -- preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end,

            -- When `true`, inserts the completion item automatically when selecting it
            -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
            -- which will both undo the selection and hide the completion menu
            auto_insert = true,
            -- auto_insert = function(ctx) return vim.bo.filetype ~= 'markdown' end
          },
          cycle = {
            -- When `true`, calling `select_next` at the _bottom_ of the completion list
            -- will select the _first_ completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the _top_ of the completion list
            -- will select the _last_ completion item.
            from_top = true,
          },
        },
        menu = {
          draw = {
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', gap = 1 }, { 'kind' } },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        -- default ={ 'lsp', 'path', 'snippets', 'buffer' }
        default = function()
          local sources = { 'lsp', 'buffer' }
          local ok, node = pcall(vim.treesitter.get_node)

          if ok and node then
            if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
              table.insert(sources, 'path')
            end
            if node:type() ~= 'string' then
              table.insert(sources, 'snippets')
            end
          end

          return sources
        end,

        per_filetype = {
          sql = { 'dadbod' },
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true },
        },
      },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      snippets = { preset = 'luasnip' },
      ghost_text = { enabled = false },
      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },

    -- NOTE: this is for neovim 0.11+
    -- config = function(_, opts)
    --   require('blink.cmp').setup(opts)
    --
    --   -- Extend neovim's client capabilities with the completion ones.
    --   vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
    -- end,
  },

  {
    'Wansmer/symbol-usage.nvim',
    event = 'BufReadPre', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
      vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

      local function text_format(symbol)
        local res = {}

        local round_start = { '', 'SymbolUsageRounding' }
        local round_end = { '', 'SymbolUsageRounding' }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0 and ('+%s'):format(symbol.stacked_count) or ''

        if symbol.references then
          local usage = symbol.references <= 1 and 'usage' or 'usages'
          local num = symbol.references == 0 and 'no' or symbol.references
          table.insert(res, round_start)
          table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
          table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
          end
          table.insert(res, round_start)
          table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
          table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
          end
          table.insert(res, round_start)
          table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
          table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= '' then
          if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
          end
          table.insert(res, round_start)
          table.insert(res, { ' ', 'SymbolUsageImpl' })
          table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
          table.insert(res, round_end)
        end

        return res
      end

      require('symbol-usage').setup {
        text_format = text_format,
      }
    end,
  },

  {
    -- NOTE: this is the only plugin that works well for python, tried vim-doge and neogen as well
    'heavenshell/vim-pydocstring',
    ft = 'python',
    build = 'make install',
    config = function()
      vim.g.pydocstring_formatter = 'google' -- 'google', 'numpy', 'sphinx'
      vim.keymap.set('n', '<leader>dg', '<Plug>(pydocstring)', { desc = 'docstring generate' })
    end,
  },

  {
    -- enable python auto fstring
    'chrisgrieser/nvim-puppeteer',
    lazy = false,
  },

  {
    'alexpasmantier/pymple.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      -- optional (nicer ui)
      'stevearc/dressing.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    build = ':PympleBuild',
    config = function()
      require('pymple').setup()
    end,
  },
}
