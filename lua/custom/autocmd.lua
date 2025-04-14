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

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float(0, {
    scope = 'cursor',
    focusable = false,
    close_events = {
      'CursorMoved',
      'CursorMovedI',
      'BufHidden',
      'InsertCharPre',
      'WinLeave',
    },
  })
end
-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup('lsp_diagnostics_hold', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function(event)
    OpenDiagnosticIfNoFloat()
  end,
  group = 'lsp_diagnostics_hold',
})
