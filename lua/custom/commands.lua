-- Clear all registers
-- vim.api.nvim_create_user_command('WipeReg', function()
--   for i = 34, 122 do
--     vim.fn.setreg(vim.fn.nr2char(i), {})
--   end
-- end, {})

-- Close all but current buffer
vim.api.nvim_create_user_command('CloseAllButCurrent', function()
  vim.cmd [[%bd|e#|bd#]]
end, {})

-- Quick fix stuff
vim.api.nvim_create_user_command('QuickFixClear', function()
  vim.fn.setqflist({}, 'r')
end, {})

vim.api.nvim_create_user_command('QuickFixUndo', function()
  vim.cmd [[cdo :norm! u]]
end, {})

vim.api.nvim_create_user_command('PyLspPostSetup', function()
  vim.cmd 'PylspInstall pylsp-rope'
end, {})
