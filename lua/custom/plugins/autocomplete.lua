return {
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
    dependencies = 'zbirenbaum/copilot.lua',
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          'onsails/lspkind.nvim',

          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local lspkind = require 'lspkind'
      local mappings = {
        -- Select the [n]ext item
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        -- Select the [p]revious item
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        -- Select the [p]revious item

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping(cmp.mapping.confirm { select = true }, { 'i', 'c' }),

        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        --['<CR>'] = cmp.mapping.confirm { select = true },
        --['<Tab>'] = cmp.mapping.select_next_item(),
        --['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        -- ['<C-Space>'] = cmp.mapping.complete {},
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<ESC>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      }

      cmp.setup {
        snippet = {
          -- you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert(mappings),
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          -- { name = 'codecompanion' },
          { name = 'luasnip' },
          { name = 'buffer', option = {
            indexing_interval = 1000,
          } },
          { name = 'path' },
          -- { name = 'copilot', group_index = 2 },
        },
        -- NOTE: taken from TJ here https://github.com/tjdevries/config_manager/blob/78608334a7803a0de1a08a9a4bd1b03ad2a5eb11/xdg_config/nvim/after/plugin/completion.lua#L129
        ---@diagnostic disable-next-line: missing-fields
        sorting = {
          -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find '^_+'
              local _, entry2_under = entry2.completion_item.label:find '^_+'
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        ---@diagnostic disable-next-line: missing-fields
        performance = {
          max_view_entries = 10,
          debounce = 25,
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format {
            -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- mode = 'symbol',
            -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            maxwidth = function()
              return math.floor(0.45 * vim.o.columns)
            end,
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function(entry, vim_item)
            --   return vim_item
            -- end,
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, item)
              local source_mapping = {
                buffer = '[Buf]',
                nvim_lsp = '[LSP]',
                copilot = ' [Copilot]',
                nvim_lua = '[Lua]',
                cmp_tabnine = '[TN]',
                path = '[Path]',
                luasnip = '[snip]',
              }

              item.menu = source_mapping[entry.source.name]
              return item
            end,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }

      cmp.setup.cmdline({ '/', '?' }, {
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
        }, {
          { name = 'buffer', option = {
            indexing_interval = 1000,
          } },
        }),
        mapping = cmp.mapping.preset.cmdline(mappings),
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        ---@diagnostic disable-next-line: missing-fields
        matching = { disallow_symbol_nonprefix_matching = false, disallow_fullfuzzy_matching = false, disallow_prefix_unmatching = false },
        mapping = cmp.mapping.preset.cmdline(mappings),
      })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
