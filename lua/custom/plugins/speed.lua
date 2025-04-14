-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  {
    'ggandor/leap.nvim',
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'gs', '<Plug>(leap)')
      vim.keymap.set('o', 'gs', '<Plug>(leap-forward)')
      -- vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
      -- vim.keymap.set('o', 'S', '<Plug>(leap-backward)')
    end,
    opts = {
      case_insensitive_regex = true,
    },
  },

  {
    -- Harpoon
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon.setup {}
      --
      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      -- vim.keymap.set('n', '<C-e>', function()
      --   toggle_telescope(harpoon:list())
      -- end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'harpoon [a]ppend' })
      -- vim.keymap.set('n', '<leader>A', function()
      --   harpoon:list():prepend()
      -- end, { desc = 'harpoon prepend' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[h]arpoon [l]ist' })
      vim.keymap.set('n', '<A-1>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<A-2>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<A-3>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<A-4>', function()
        harpoon:list():select(4)
      end)
      vim.keymap.set('n', '<A-5>', function()
        harpoon:list():select(5)
      end)
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<A-p>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<A-n>', function()
        harpoon:list():next()
      end)
    end,
  },
}
