return {

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      --   f, t, F, T motions:
      -- After typing f{char} or F{char}, you can repeat the motion with f or go to the previous match with F to undo a jump.
      -- Similarly, after typing t{char} or T{char}, you can repeat the motion with t or go to the previous match with T.
      -- You can also go to the next match with ; or previous match with ,
      -- Any highlights clear automatically when moving, changing buffers, or pressing <esc>.
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
}
