return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {
      fast_wrap = {},
      disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'snacks_picker_input' },
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', function(args)
        -- NOTE: check if the current line matches a python import regex, if so don't auto complete pairs
        local line = vim.api.nvim_get_current_line()
        local is_python_import = line:match '^%s*import%s+.*$' or line:match '^%s*from%s+.*$'
        if is_python_import then
          return
        end
        cmp_autopairs.on_confirm_done()(args)
      end)
    end,
  },
}
