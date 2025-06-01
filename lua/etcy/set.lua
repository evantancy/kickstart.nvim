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

-- -- move line text up/down in insert mode
-- vim.keymap.set('i', '<c-j>', '<esc>:m .+1<CR>==gi', { noremap = true })
-- vim.keymap.set('i', '<c-k>', '<esc>:m .-2<CR>==gi', { noremap = true })

-- delete without yanking
-- replace currently selected text with unnamed register without yanking
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')
vim.keymap.set('x', '<leader>p', '"_dP', { noremap = true })
vim.keymap.set('n', '<leader>D', '"_D', { noremap = true })
-- vim.keymap.set('n', '<leader>C', '"_C', { noremap = true })
-- NOTE: conflicts with <leader>ca
-- vim.keymap.set('n', '<leader>c', '"_c', { noremap = true })
vim.keymap.set('n', '<leader>x', '"_x', { noremap = true })

-- from primeagen
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

-- make vim behave properly, like c & C, d & D
vim.keymap.set('n', 'Y', 'y$', { noremap = true })

-- maintain cursor position while scrolling up/down
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

-- navigate TODO items
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next TODO comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous TODO comment' })

-- quickfix list
vim.keymap.set('n', ']q', ':cnext<cr>', { desc = 'next quickfix list item' })
vim.keymap.set('n', '[q', ':cprev<cr>', { desc = 'prev quickfix list item' })

-- undotree
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>')

-- moving around in vim commandline
vim.keymap.set('c', '<c-h>', '<left>')
vim.keymap.set('c', '<c-j>', '<down>')
vim.keymap.set('c', '<c-k>', '<up>')
vim.keymap.set('c', '<c-l>', '<right>')
vim.keymap.set('c', '^', '<home>')
vim.keymap.set('c', '$', '<end>')

-- D duplicates highlighted text below
vim.keymap.set('v', 'D', "y'>p", { noremap = true })

-- tab while code selected
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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
vim.keymap.set('n', 'sh', ':split<CR><C-w>w', { silent = true, desc = 'split horizontally' })
vim.keymap.set('n', 'sv', ':vsplit<CR><C-w>w', { silent = true, desc = 'split vertically' })
vim.keymap.set('n', 'sc', '<c-w>o<cr>', { silent = true, desc = 'split close, all other splits but active split' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
