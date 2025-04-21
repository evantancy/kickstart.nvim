local M = {}
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values

-- define some constants
local ActionType = {
  lsp = 'builtin LSP',
  refactoring = 'refactoring.nvim',
}

local function apply_action(action, client)
  local offset_encoding = client.offset_encoding

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, offset_encoding)
  end

  if action.command then
    local command = type(action.command) == 'table' and action.command or action
    vim.lsp.buf.execute_command(command)
  end
end

-- on action being selected via picker
local on_action_select = function(prompt_bufnr)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)

    local selection = action_state.get_selected_entry()
    local client_id = selection.value.client_id
    local client_name = selection.value.client_name
    local action = selection.value.action
    local context = selection.value.context
    local type = selection.value.type
    local client = vim.lsp.get_client_by_id(client_id)
    if client == nil then
      vim.notify('Client not found for client_id: ' .. client_id, vim.log.levels.ERROR)
      return
    end

    local reg = client.dynamic_capabilities:get('textDocument/codeAction', { bufnr = current_bufnr })
    local support_resolve = vim.tbl_get(reg or {}, 'registerOptions', 'resolveProvider') or client.supports_method 'codeAction/resolve'

    if client and support_resolve then
      client.request('codeAction/resolve', action, function(err, resolved_action)
        if err then
          vim.notify('Error resolving code action: ' .. vim.inspect(err), vim.log.levels.ERROR)
          return
        end

        apply_action(resolved_action, client)
      end)
    else
      apply_action(action, client)
    end

    -- map('n', '<CR>', actions.select_default)
    -- map('i', '<CR>', actions.select_default)
  end)
  return true
end

-- main function
local code_actions_picker = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local current_bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }

  local current_buf_id = 0
  vim.lsp.buf_request_all(current_buf_id, 'textDocument/codeAction', params, function(results)
    -- TODO: integrate with prime's refactoring.nvim!!
    local actions_list = {}
    for client_id, result in pairs(results) do
      if result.result and not vim.tbl_isempty(result.result) then
        local client_name = vim.lsp.get_client_by_id(client_id).name
        for _, action in ipairs(result.result) do
          table.insert(actions_list, {
            client_id = client_id,
            client_name = client_name,
            action = action,
            context = result.result.context,
            type = ActionType.lsp,
          })
        end
      end
    end

    if vim.tbl_isempty(actions_list) then
      vim.notify('No code actions available!', vim.log.levels.INFO)
      return
    end

    pickers
      .new(opts, {
        prompt_title = 'Code Actions (Extended)',
        finder = finders.new_table {
          results = actions_list,
          entry_maker = function(entry)
            local client_id = entry.client_id
            local client_name = entry.client_name
            local action = entry.action
            local context = entry.context
            local type = entry.type

            local entry_display = '[' .. client_name .. ' (' .. client_id .. ') ' .. '] ' .. action.title .. ' (' .. action.kind .. ')'

            return {
              value = entry,
              display = entry_display,
              -- NOTE: we make sorting/filtering by entry.action.kind available by including it in the message
              ordinal = entry_display,
            }
          end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = on_action_select,
      })
      :find()
  end)
end

M.setup = function()
  vim.keymap.set({ 'n', 'x' }, '<leader>ca', code_actions_picker, { desc = 'Code actions' })
end

return M
