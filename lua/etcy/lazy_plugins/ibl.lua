return {
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      scope = {
        enabled = true,
        -- show_exact_scope = true,
        -- show_end = true,
        -- show_start = true,
      },
      -- indent = { tab_char = '▎' },
    },
  },
}
