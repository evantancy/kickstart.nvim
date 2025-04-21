--  See `:help lua-guide-autocommands`

-- Disable automatic comment insertion, except when pressing Enter
vim.opt.formatoptions = vim.opt.formatoptions
  + {
    c = false,
    o = false, -- o and O don't continue comments
    r = true, -- Pressing Enter will continue comments
  }
vim.cmd [[
    autocmd FileType * setlocal formatoptions-=c formatoptions+=r formatoptions-=o
]]


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 150 }
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
