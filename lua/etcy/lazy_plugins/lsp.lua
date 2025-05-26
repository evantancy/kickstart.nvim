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
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      -- Only show the highest severity diagnostic
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return diagnostic.message
      end

      -- Check if there are any ERROR diagnostics at the same line
      local line_diagnostics = vim.diagnostic.get(0, {
        lnum = diagnostic.lnum,
      })

      for _, d in ipairs(line_diagnostics) do
        if d.severity < diagnostic.severity then
          -- A more severe diagnostic exists (lower number = higher severity)
          return nil
        end
      end

      return diagnostic.message
    end,
  },
}

return {
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mason-org/mason.nvim',
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
          python = { 'ruff_fix', 'ruff_format' },
          prisma = { 'prismals' },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
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

      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      {
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      require('mason-lspconfig').setup {
        automatic_installation = true,
        ensure_installed = {
          'lua_ls',
          'gopls',
          'pyright',
          -- 'sourcery',
          'ts_ls',
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
            lspconfig.lua_ls.setup {
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

          ['pyright'] = function()
            lspconfig.pyright.setup {
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

      local cmp = require 'cmp'
      require('cmp').setup {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<esc>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        ---@diagnostic disable-next-line: missing-fields
        performance = {
          max_view_entries = 10,
          debounce = 25,
        },
        formatting = {
          format = require('lspkind').cmp_format {
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = {
              -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- menu = function() return math.floor(0.45 * vim.o.columns) end,
              menu = 50, -- leading text (labelDetails)
              abbr = 50, -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              -- ...
              return vim_item
            end,
          },
        },
      }
    end,
  },
}
