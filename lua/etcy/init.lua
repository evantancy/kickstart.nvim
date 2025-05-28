_G.custom_ignore_filetypes = {
  'dirbuf',
  'dirvish',
  'fugitive',
  'TelescopePrompt',
  'spectre_panel',
  'snacks_picker_input',
  'oil',
}

local source_env_vars = function()
  local handle = io.popen 'EDITOR=cat sops -d ~/.openrouter-api-key.enc 2>/dev/null'
  local result = handle and handle:read '*a' or ''
  if handle then
    handle:close()
  end

  vim.env.OPENAI_API_KEY = result:match 'OPENROUTER_API_KEY=(%S+)'
  vim.env.ANTHROPIC_API_KEY = result:match 'OPENROUTER_API_KEY=(%S+)'
  vim.env.OPENROUTER_API_KEY = result:match 'OPENROUTER_API_KEY=(%S+)'
end

source_env_vars()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup lazy.nvim
require('lazy').setup {
  spec = {
    -- import your plugins
    { import = 'etcy.lazy_plugins' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = false },
  change_detection = {
    enabled = true,
    notify = false,
  },
}

require 'etcy.autocmd'
require 'etcy.opt'
require 'etcy.set'
