-- Misc
vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.errorbells = false -- Disable annoying sounds
vim.opt.virtualedit = 'block' -- Allow rectangular selections, see https://medium.com/usevim/vim-101-virtual-editing-661c99c05847
vim.opt.syntax = 'enable' -- Enable syntax highlighting
vim.cmd [[]]

-- Search
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Text objects
vim.opt.iskeyword = vim.opt.iskeyword + '-' -- Treat dash separated words as a word text object
vim.opt.wrap = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Tabs and Indentation
vim.opt.smarttab = true -- Makes tabbing smarter, will use shiftwidths instead of tabstop in some cases
vim.opt.smartindent = true
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 4 -- Number of spaces for tab
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- Number of spaces for indentation

-- Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true -- Save undo history
vim.opt.undodir = os.getenv 'XDG_DATA_HOME' .. '/.vim/undodir'

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes:2'

-- Looks
vim.opt.colorcolumn = '80' -- show column
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.cursorline = true -- highlight current line number
vim.opt.termguicolors = true

-- Timing
vim.opt.updatetime = 100
vim.opt.timeoutlen = 200 -- Decrease mapped sequence wait time

-- Auto-read files when changed outside vim
vim.opt.autoread = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- NOTE: uncomment to be able to see these chars
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = '·', eol = '↴' }
