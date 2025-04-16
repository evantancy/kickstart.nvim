local M = {}

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

local live_multigrep = function(opts)
  opts = opts or {}

  opts.cwd = opts.cwd or vim.uv.cwd()
  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end
      -- NOTE: use a double space after searching using telescope to filter for certain filetypes
      -- only!
      local pieces = vim.split(prompt, '  ')

      local args = { 'rg' }
      if pieces[1] then
        -- table.insert(args, '-e')
        -- table.insert(args, pieces[1])

        -- NOTE: enables fuzzy when ...
        -- Check if the first character is "~"
        if pieces[1]:sub(1, 1) == '~' then
          -- Remove the "~" character from the beginning of the search pattern
          local search_pattern = pieces[1]:sub(2) -- Extract everything after the "~"
          -- Convert the search pattern to fuzzy matching pattern
          local fuzzy_pattern = search_pattern:gsub('.', function(c)
            return '[^' .. c .. ']*' .. c
          end)
          table.insert(args, '-e')
          table.insert(args, fuzzy_pattern)
        else
          -- Use the exact search pattern if "~" is not the first character
          table.insert(args, '-e')
          table.insert(args, pieces[1])
        end
      end

      if pieces[2] then
        table.insert(args, '-g')
        table.insert(args, pieces[2])
      end

      return vim.tbl_flatten {
        args,
        {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--hidden',
          '--smart-case',
        },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }
  pickers
    .new(opts, {
      debounce = 50,
      prompt_title = 'Live Multigrep',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      -- sorter = require('telescope.sorters').empty(),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

M.setup = function()
  vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = 'Live Multigrep' })
end

return M
