local M = {}

function M.get_diagnostic_label_table(buf)
  local icons = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
  local label = {}
  local buffer = buf or 0

  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(buffer, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
    end
  end
  if #label > 0 then
    table.insert(label, { '┊ ' })
  end
  return label
end

return M
