return {
  {

    'folke/trouble.nvim',
    opts = {
      warn_no_results = false,
      open_no_results = true,
      win = {
        wo = {
          -- false diagnostics text wrapping
          wrap = false,
        },
      },

      modes = {
        ---@class trouble.Mode: trouble.Config,trouble.Section.spec
        diagnostics_preview = {
          groups = {
            { 'filename', format = '{file_icon} {basename:Title} {count}' },
          },
          mode = 'diagnostics',

          -- ---@type trouble.Window.opts
          -- preview = {
          --   type = 'split',
          --   relative = 'win',
          --   position = 'right',
          --   size = 0.4,
          -- },
          filter = {
            any = {
              -- NOTE: remove buffer limitation once more stable
              -- buf = 0, -- current buffer
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
    dependencies = { 'ibhagwan/fzf-lua' },
    keys = {
      {
        '<leader>tt',
        '<cmd>Trouble diagnostics_preview toggle focus=true<cr>',
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
        '<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.3<cr>',
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
}
