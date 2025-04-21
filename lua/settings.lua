-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- mini.nvim
vim.g.minipairs_disable = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.opt.number = true
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Disable annoying sounds
vim.opt.errorbells = false
-- Treat dash separated words as a word text object
vim.opt.iskeyword = vim.opt.iskeyword + '-'

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
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters
-- vim.opt.breakindent = true -- Wrapped lines will continue visually indented (same amount of space as the beginning of that line)
vim.opt.expandtab = true -- Convert tabs to spaces

vim.opt.tabstop = 4 -- Number of spaces for tab
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- Number of spaces for indentation
vim.opt.virtualedit = 'block' -- Allow rectangular selections, see https://medium.com/usevim/vim-101-virtual-editing-661c99c05847

-- Save undo history
vim.opt.undofile = true
vim.cmd [[
    set undodir=$XDG_DATA_HOME/.vim/undodir
  ]]
vim.opt.syntax = 'enable' -- Enable syntax highlighting

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 100

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 200

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- NOTE: uncomment to be able to see these chars
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = '·', eol = '↴' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Aesthetics
vim.opt.title = true
vim.opt.colorcolumn = '80' -- Show column
vim.opt.linebreak = true -- Break by word, not character
vim.opt.ruler = true
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 10 -- Keep X lines above/below cursor when scrolling
vim.opt.cursorline = true -- Show cursor position all the time
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.cursorlineopt = 'number,screenline' -- disable highlighting the entire line
-- Backups
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.backup = false

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- make Ctrl-C escape
vim.keymap.set({ 'n', 'x', 'i' }, '<C-c>', '<Esc>', { noremap = true })
-- navigate around wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true })
-- navigate buffer
vim.keymap.set('n', '<tab>', '<cmd>bnext<cr>', { noremap = true })
vim.keymap.set('n', '<s-tab>', '<cmd>bprevious<cr>', { noremap = true })
-- moving lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })
-- move line text up/down in normal mode
vim.keymap.set('n', '<leader>j', ':m .+1<CR>==', { noremap = true })
vim.keymap.set('n', '<leader>k', ':m .-2<CR>==', { noremap = true })
-- move line text up/down in insert mode
vim.keymap.set('i', '<c-j>', '<esc>:m .+1<CR>==gi', { noremap = true })
vim.keymap.set('i', '<c-k>', '<esc>:m .-2<CR>==gi', { noremap = true })
-- delete without yanking
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')
-- make vim behave properly, like c & C, d & D
vim.keymap.set('n', 'Y', 'y$', { noremap = true })
-- maintain cursor in middle while scrolling up/down
vim.keymap.set('n', '<C-d>', '10<C-d>zz')
vim.keymap.set('n', '<C-u>', '10<C-u>zz')
-- maintain cursor in middle while going through search matches
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })
-- maintain cursor at current position when joining lines
vim.keymap.set('n', '<leader>J', 'mzJ`z', { noremap = true })
-- break undo sequence using punctuation marks
vim.keymap.set('i', ',', ',<c-g>u', { noremap = true })
vim.keymap.set('i', '.', '.<c-g>u', { noremap = true })
vim.keymap.set('i', '!', '!<c-g>u', { noremap = true })
vim.keymap.set('i', '?', '?<c-g>u', { noremap = true })
-- replace currently selected text with default register without yanking
vim.keymap.set('v', 'p', '"_dP', { noremap = true })
vim.keymap.set('n', '<leader>D', '"_D', { noremap = true })
vim.keymap.set('n', '<leader>C', '"_C', { noremap = true })
vim.keymap.set('n', '<leader>c', '"_c', { noremap = true })
vim.keymap.set('n', '<leader>x', '"_x', { noremap = true })

-- navigate TODO items
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next [T]ODO comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous [T]ODO comment' })

-- undotree
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>')

-- -- resize windows
-- -- TODO fix for MacOS
-- vim.keymap.set('n', '<C-left>', '<C-w><', opts)
-- vim.keymap.set('n', '<C-right>', '<C-w>>', opts)
-- vim.keymap.set('n', '<C-up>', '<C-w>+', opts)
-- vim.keymap.set('n', '<C-down>', '<C-w>-', opts)

-- TODO: go through these ...
-- -- moving around in vim commandline
vim.keymap.set('c', '<c-h>', '<left>')
vim.keymap.set('c', '<c-j>', '<down>')
vim.keymap.set('c', '<c-k>', '<up>')
vim.keymap.set('c', '<c-l>', '<right>')
vim.keymap.set('c', '^', '<home>')
vim.keymap.set('c', '$', '<end>')

-- -- quickfix list
vim.keymap.set('n', ']q', ':cnext<cr>')
vim.keymap.set('n', '[q', ':cprev<cr>')

-- -- increment/decrement
-- vim.keymap.set('n', '+', '<c-a>')
-- vim.keymap.set('n', '_', '<c-x>')

-- make vim behave
-- D duplicates highlighted text below
vim.keymap.set('v', 'D', "y'>p", { noremap = true })
-- tab while code selected
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- Telescope | ff -> find file | fg -> find grep | fb -> find buffer
-- Telescope | dl -> diagnostics list | fa -> find all
vim.keymap.set('n', '<leader>vrc', function()
  require('telescope.builtin').find_files {
    prompt_title = '< VimRC Find Files >',
    cwd = '$DOTFILES',
    hidden = true,
  }
end, { desc = '[V]im[RC] Find Files' })
vim.keymap.set('n', '<leader>vrg', function()
  require('telescope.builtin').live_grep {
    prompt_title = '< VimRC Live Grep >',
    cwd = '$DOTFILES',
  }
end, { desc = '[V]imRC Live [G]rep' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- NOTE: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- split window management

vim.keymap.set('n', 'sh', ':split<CR><C-w>w', { silent = true, desc = '[s]plit [h]orizontally' })
vim.keymap.set('n', 'sv', ':vsplit<CR><C-w>w', { silent = true, desc = '[s]plit [v]ertically' })
vim.keymap.set('n', 'sc', '<c-w>o<cr>', { silent = true, desc = '[s]plit [c]lose, all other splits but active split' })
