local M = {}

-- TODO: add prime's refactoring.nvim to code actions

-- Function to get code actions as a table from all LSPs
function M.GetCodeActions()
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }

  vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, function(results)
    if not results or vim.tbl_isempty(results) then
      print 'No code actions available'
      return
    end

    -- Collect all code actions from all servers
    local actions = {}
    for client_id, result in pairs(results) do
      if result.result and not vim.tbl_isempty(result.result) then
        for _, action in ipairs(result.result) do
          -- Add client_id to each action for tracking
          action.client_id = client_id
          table.insert(actions, action)
        end
      end
    end

    -- Print out available actions
    if vim.tbl_isempty(actions) then
      print 'No code actions available'
    else
      print 'Available code actions:'
      for i, action in ipairs(actions) do
        local client_name = vim.lsp.get_client_by_id(action.client_id).name or 'unknown'
        print(i .. ': [' .. client_name .. '] ' .. (action.title or 'Unnamed action'))
      end

      -- let's print them out in a new buffer

      -- Convert table to a formatted string
      local output = vim.inspect(actions)
      -- Create a new empty buffer
      vim.cmd 'enew'
      -- Split the output into individual lines
      local lines = vim.split(output, '\n')
      -- Set the lines in the current buffer (starting at line 0)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

      -- Store actions in a global variable for later use
      _G.current_code_actions = actions
    end
  end)
end -- Map to a key if desired

M.setup = function()
  vim.keymap.set('n', '<leader>cA', M.GetCodeActions, { desc = 'Code actions extended' })
end

return M
