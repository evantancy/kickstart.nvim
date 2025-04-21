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

require 'settings'
require 'autocmd'
require 'filetype'
require 'commands'
require 'lazy_init'
