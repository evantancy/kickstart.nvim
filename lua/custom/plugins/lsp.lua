vim.lsp.inlay_hint.enable(true)
vim.g.inlay_hints_visible = true

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

-- toggle diagnostics for current buffer
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = '[T]oggle [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Goto prev [d]iagnostic' })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Goto next [d]iagnostic' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Goto previous error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Goto next error' })

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
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    lazy = false,
    config = function()
      local refactoring = require 'refactoring'
      refactoring.setup {}
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
    'chrisgrieser/nvim-puppeteer',
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },

  {
    'folke/trouble.nvim',
    opts = {
      warn_no_results = false,
      open_no_results = true,

      modes = {
        ---@class trouble.Mode: trouble.Config,trouble.Section.spec
        diagnostics_preview = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
          filter = {
            any = {
              buf = 0, -- current buffer
              {
                severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
                -- NOTE: limit to files in the current project
                function(item)
                  return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                end,
              },
            },
          },
        },
        symbols_custom = {
          mode = 'symbols',
          preview = {
            type = 'split',
            relative = 'editor',
            position = 'right',
            size = 10,
          },
        },
      },
    }, -- for default options, refer to the configuration section for custom setup.
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
        '<cmd>Trouble diagnostics_preview toggle<cr>',
        desc = '[T]rouble Diagnostics',
      },
      {
        '<leader>tT',
        '<cmd>Trouble diagnostics_preview toggle filter.buf=0<cr>',
        desc = '[T]rouble Buffer Diagnostics',
      },
      {
        '<leader>ts',
        '<cmd>Trouble symbols_custom toggle focus=false<cr>',
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

  -- {
  --   'stevearc/quicker.nvim',
  --   event = 'FileType qf',
  --   ---@module "quicker"
  --   ---@type quicker.SetupOptions
  --   config = function()
  --     require('quicker').setup {
  --       follow = {
  --         -- When quickfix window is open, scroll to closest item to the cursor
  --         enabled = true,
  --       },
  --     }
  --   end,
  -- },

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
      -- change the highlight style
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })

      --- auto update the highlight style on colorscheme change
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        pattern = { '*' },
        callback = function(event)
          vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
          vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
          vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
        end,
      })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      -- NOTE: enable line numbers in telescope previewer
      vim.cmd 'autocmd User TelescopePreviewerLoaded setlocal number'
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Find references for the word under your cursor.
          -- goto references
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- map('gr', require('fzf-lua').lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- goto implementation
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          --  goto type definition
          map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>sd', require('telescope.builtin').lsp_document_symbols, 'Search [S]ymbols in [D]ocument ')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Search [S]ymbols in [W]orkspace')
          -- map('<leader>sw', function()
          --   require('fzf-lua').lsp_live_workspace_symbols { winopts = { preview = { layout = 'vertical', vertical = 'up:60%' } } }
          -- end, 'Search Symbols in Workspace')

          -- map('gs', vim.lsp.buf.signature_help, '[G]oto [S]ignature')

          map('K', vim.lsp.buf.hover, 'Show LSP stuff under cursor')
          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>cA', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('<leader>gd', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            -- NOTE: define custom LSP highlights here
            vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#3a3a3a' })
            vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#264f78' })
            vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#4b1818' })
            vim.api.nvim_set_hl(0, 'LspCodeLens', { fg = '#999999', italic = true })
            vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { bold = true, underline = true })

            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_definition, event.buf) then
            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            -- NOTE: trying out fzflua, we do this to allow peeking without navigating
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            -- map('gd', function()
            --   require('fzf-lua').lsp_definitions { jump1 = false }
            -- end, 'Peek definition')
            -- map('gD', function()
            --   require('fzf-lua').lsp_definitions { jump1 = true }
            -- end, 'Go to definition')
          end
        end,
      })

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

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

      -- NOTE: to fix pyright hover wrong formatting
      local util = require 'vim.lsp.util'
      -- The function that replace those quirky html symbols.
      local function split_lines(value)
        value = string.gsub(value, '&nbsp;', ' ')
        value = string.gsub(value, '&gt;', '>')
        value = string.gsub(value, '&lt;', '<')
        value = string.gsub(value, '\\', '')
        value = string.gsub(value, '```python', '')
        value = string.gsub(value, '```', '')
        return vim.split(value, '\n', { plain = true, trimempty = true })
      end

      -- The function name is the same as what you found in the neovim repo.
      -- I just remove those unused codes.
      -- Actually, this function doesn't "convert input to markdown".
      -- I just keep the function name the same for reference.
      local function convert_input_to_markdown_lines(input, contents)
        contents = contents or {}
        assert(type(input) == 'table', 'Expected a table for LSP input')
        if input.kind then
          local value = input.value or ''
          vim.list_extend(contents, split_lines(value))
        end
        if (contents[1] == '' or contents[1] == nil) and #contents == 1 then
          return {}
        end
        return contents
      end

      -- The overwritten hover function that pyright uses.
      -- Note that other language server can use the default one.
      local function hover(_, result, ctx, config)
        config = config or {}
        config.focus_id = ctx.method
        if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
          -- Ignore result since buffer changed. This happens for slow language servers.
          return
        end
        if not (result and result.contents) then
          if config.silent ~= true then
            vim.notify 'No information available'
          end
          return
        end
        local contents ---@type string[]
        contents = convert_input_to_markdown_lines(result.contents)
        if vim.tbl_isempty(contents) then
          if config.silent ~= true then
            vim.notify 'No information available'
          end
          return
        end
        -- Notice here. The "plaintext" string was originally "markdown".
        -- The reason of using "plaintext" instead of "markdown" is becasue
        -- of the bracket characters ([]). Markdown will hide single bracket,
        -- so when your docstrings consist of numpy or pytorch or python list,
        -- you will get garbadge hover results.
        -- The bad side of "plaintext" is that you never get syntax highlighting.
        -- I personally don't care about this.
        return util.open_floating_preview(contents, 'plaintext', config)
      end

      ---@type lspconfig.options
      local servers = {
        -- clangd = {},
        gopls = {},
        marksman = {},

        -- NOTE: use pyright for type checking,
        -- use basedpyright for inlay hints + better code actions
        -- use ruff for formatting
        -- FIXME: both pyright and basedpyright tryna rename symbol at the same time
        pyright = {
          -- use Ruff's import organizer
          disableOrganizeImports = true,
          filetypes = { 'python' },
          settings = {
            python = {
              analysis = {
                -- Ignore all files for analysis to exlusively use Ruff for linting
                -- ignore = { '*' },
                autoSearchPaths = true,
                diagnosticMode = 'workspace', -- 'workspace' | 'openFilesOnly'
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
                autoImportCompletions = true,
              },
            },
          },
          handlers = {
            ['textDocument/codeAction'] = function() end,
            ['textDocument/rename'] = function() end,
            ['codeAction/resolve'] = function() end,
            -- ['textDocument/references'] = function() end,
            ['textDocument/hover'] = vim.lsp.with(hover, {
              border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
              title = ' |･ω･) ? ',
              max_width = 120,
              zindex = 500,
            }),
          },
        },
        basedpyright = {
          -- use Ruff's import organizer
          disableOrganizeImports = true,
          filetypes = { 'python' },
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace', -- 'workspace' | 'openFilesOnly'
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportWildcardImportFromLibrary = 'error',
                  reportUnusedImport = 'information',
                  reportUnusedClass = 'information',
                  reportUnusedFunction = 'warning',
                  reportOptionalMemberAccess = 'error',
                  reportUnknownVariableType = 'warning',
                  reportUnusedCallResult = 'none',
                },
              },
            },
          },

          handlers = {
            ['textDocument/publishDiagnostics'] = function() end,
            -- ['textDocument/rename'] = function() end,
            ['textDocument/hover'] = vim.lsp.with(hover, {
              border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
              title = ' |･ω･) ? ',
              max_width = 120,
              zindex = 500,
            }),
          },
        },

        ruff = {
          -- NOTE: disable LSP disagnostics for ruff
          handlers = {
            ['textDocument/publishDiagnostics'] = function() end,
            ['textDocument/rename'] = function() end,
          },
        },
        -- pylsp = {
        --   -- see https://github.com/python-lsp/python-lsp-server#configuration
        --   configurationSources = { '' },
        --   plugins = {
        --     pycodestyle = { enabled = false, ignore = { 'E501', 'E302', 'E303', 'W391', 'F401', 'E402', 'E265' } },
        --     flake8 = { enabled = false, ignore = { 'E501', 'E302', 'E303', 'W391', 'F401', 'E402', 'E265' } },
        --     jedi_completion = { enabled = false },
        --     jedi_definition = { enabled = false },
        --     jedi_hover = { enabled = false },
        --     jedi_references = { enabled = false },
        --     jedi_signature_help = { enabled = false },
        --     jedi_symbols = { enabled = false, all_scopes = false, include_import_symbols = false },
        --     preload = { enabled = false, modules = { 'numpy', 'scipy' } },
        --     mccabe = { enabled = false },
        --     mypy = { enabled = false },
        --     isort = { enabled = false },
        --     spyder = { enabled = false },
        --     memestra = { enabled = false },
        --     pyflakes = { enabled = false },
        --     yapf = { enabled = false },
        --     pylint = {
        --       enabled = false,
        --     },
        --     rope = { enabled = true },
        --     rope_completion = { enabled = false, eager = false },
        --   },
        -- },
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }
      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      -- NOTE: `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prismals',
        'shellcheck',
      })

      -- Function to check if "ruff" command is available
      local function is_ruff_available()
        local handle = io.popen 'command -v ruff'
        if handle == nil then
          return false
        end
        local result = handle:read '*a'
        handle:close()
        return result ~= ''
      end

      -- NOTE: this works but just remember to enter the venv before entering nvim
      if not is_ruff_available() then
        vim.list_extend(ensure_installed, {
          'ruff',
        })
      end

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      -- { 'nvim-telescope/telescope-frecency.nvim' },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- NOTE: Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`

      local actions = require 'telescope.actions'
      local sorters = require 'telescope.sorters'
      local open_with_trouble = require('trouble.sources.telescope').open

      -- Use this to add more results without clearing the trouble list
      -- local add_to_trouble = require('trouble.sources.telescope').add

      local telescope = require 'telescope'

      telescope.setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- NOTE: use <C-/> or "?" to see all keymaps
        defaults = {
          mappings = {
            i = {
              -- consistent with fzf-lua if i ever change
              ['<C-g>'] = actions.to_fuzzy_refine, -- convert non-fuzzy to fuzzy
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.send_to_qflist,
              ['<C-t>'] = open_with_trouble,
              ['<C-d>'] = actions.delete_buffer,
              ['<C-f>'] = actions.preview_scrolling_down,
              ['<C-b>'] = actions.preview_scrolling_up,
            },
            n = {
              -- consistent with fzf-lua if i ever change
              ['<C-g>'] = actions.to_fuzzy_refine, -- convert non-fuzzy to fuzzy
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.send_to_qflist,
              ['<C-t>'] = open_with_trouble,
              ['<C-d>'] = actions.delete_buffer,
              ['<C-f>'] = actions.preview_scrolling_down,
              ['<C-b>'] = actions.preview_scrolling_up,
              ['<C-c>'] = actions.close,
              ['<esc>'] = actions.close,
            },
          },
          dynamic_preview_title = true,
          -- history = false,
          layout_strategy = 'vertical',
          layout_config = {
            scroll_speed = 10,
            horizontal = {
              height = 0.95,
              preview_cutoff = 80,
              preview_width = 0.7,
              prompt_position = 'bottom',
              width = 0.95,
            },
          },
          vimgrep_arguments = {
            'rg',
            -- '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--hidden',
            '--smart-case',
            '--glob=!.git/',
          },
          prompt_prefix = '🔍 ',
          selection_caret = '>> ',
          color_devicons = true,
          path_display = {
            shorten = { len = 2, exclude = { 1, -1 } },
          },
          file_ignore_patterns = { 'node_modules/.*', '%.git/.*', '%.idea/.*', '%.vscode/.*' },
          sorting_strategy = 'ascending',
          file_sorter = sorters.get_fzf_sorter,
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        pickers = {
          live_grep = {
            on_input_filter_cb = function(prompt)
              -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
              return { prompt = prompt:gsub('%s', '.*') }
            end,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {
              previewer = false,
              initial_mode = 'normal',
              sorting_strategy = 'ascending',
              layout_strategy = 'vertical',
              prompt_position = 'bottom',
              layout_config = {
                horizontal = {
                  width = 0.5,
                  height = 0.4,
                  preview_width = 0.6,
                },
              },
            },
          },
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          -- the default case_mode is "smart_case"
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        },
      }

      -- Enable Telescope extensions if they are installed
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'ui-select'
      require('telescope').load_extension 'todo-comments'
      -- pcall(require('telescope').load_extension, 'frecency')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files {
          -- hidden = true,
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        }
      end, { desc = '[S]earch [F]iles' })
      -- map('<leader>sf', function()
      --   require('fzf-lua').files { file_icons = true, winopts = { split = 'belowright new' } }
      -- end, 'Search Files')

      vim.keymap.set('n', '<leader><C-e>', builtin.command_history, { desc = 'Open command history in Telescope' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

      -- NOTE: disabled in favor of custom buffer delete funcs
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]each open [B]uffers' })
      -- NOTE: disabled in favor of multigrep
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>se', function()
        builtin.diagnostics {
          layout_strategy = 'vertical',
        }
      end, { desc = '[S]earch [E]rrors and Diagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
      -- NOTE: telescope specific custom plugins
      require('kickstart.plugins.telescope-multigrep').setup()
      require('kickstart.plugins.telescope-codeaction').setup()
    end,
  },

  {
    'Wansmer/symbol-usage.nvim',
    enabled = true,
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
        ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
        vt_position = 'above',
      }
    end,
  },

  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    },
    -- or use config
    -- config = function(_, opts) require'lsp_signature'.setup({you options}) end
  },
}
