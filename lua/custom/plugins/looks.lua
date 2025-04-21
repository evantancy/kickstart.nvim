-- TODO: if these aren't being used, what's setting color?
-- hl-groups can have any name
-- vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
-- vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
-- vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
-- vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
-- vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

-- vim.cmd [[ hi def IlluminatedWordText gui=underline cterm=underline ]]
-- vim.cmd [[ hi def IlluminatedWordRead gui=underline cterm=underline ]]
-- vim.cmd [[ hi def IlluminatedWordWrite gui=underline cterm=underline ]]

-- -- change the highlight style
-- vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
-- vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
-- vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })

--- auto update the highlight style on colorscheme change
-- vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
--   pattern = { '*' },
--   callback = function(event)
--     vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
--     vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
--     vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
--   end,
-- })

return {

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    dependencies = {
      { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = ... },
      { 'loctvl842/monokai-pro.nvim' },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- style = 'night', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'dark', -- style for sidebars, see below
          floats = 'dark', -- style for floating windows
        },
      }
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.o.background = 'dark'
      -- vim.cmd.colorscheme 'gruvbox'
      -- vim.cmd.colorscheme 'monokai-pro'
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
  },
}
