vim.cmd [[
    hi BqfPreviewBorder guifg=#3e8e2d ctermfg=71
    hi BqfPreviewTitle guifg=#3e8e2d ctermfg=71
    hi BqfPreviewThumb guibg=#3e8e2d ctermbg=71
    hi link BqfPreviewRange Search
]]

return {
  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup {
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable

        -- full keymap from https://github.com/kevinhwang91/nvim-bqf?tab=readme-ov-file#function-table
        func_map = {
          open = '<CR>', --	open the item under the cursor
          openc = 'o', --	open the item and close quickfix window
          drop = 'O', --	use drop to open the item and close quickfix window
          -- tabdrop = '', --	use tab drop to open the item and close quickfix window
          tab = 't', --	open the item in a new tab
          tabb = 'T', --	open the item in a new tab but stay in quickfix window
          tabc = '<C-t>', --	open the item in a new tab and close quickfix window
          split = '<C-x>', --	open the item in horizontal split
          vsplit = '<C-v>', --	open the item in vertical split
          prevfile = '<C-p>', --	go to previous file under the cursor in quickfix window
          nextfile = '<C-n>', --	go to next file under the cursor in quickfix window
          prevhist = '<', --	cycle to previous quickfix list in quickfix window
          nexthist = '>', --	cycle to next quickfix list in quickfix window
          lastleave = '', --	go to last selected item in quickfix window
          stoggleup = '<S-Tab>', --	toggle sign and move cursor up
          stoggledown = '<Tab>', --	toggle sign and move cursor down
          stogglevm = '<Tab>', --	toggle multiple signs in visual mode
          stogglebuf = '<Tab>', --	toggle signs for same buffers under the cursor
          sclear = 'z<Tab>', --	clear the signs in current quickfix list
          pscrollup = '<C-b>', --	scroll up half-page in preview window
          pscrolldown = '<C-f>', --	scroll down half-page in preview window
          pscrollorig = 'zo', --	scroll back to original position in preview window
          ptogglemode = 'zp', --	toggle preview window between normal and max size
          ptoggleitem = 'p', --	toggle preview for a quickfix list item
          ptoggleauto = 'P', --	toggle auto-preview when cursor moves
          filter = 'qn', --	create new list for signed items
          filterr = 'qN', --	create new list for non-signed items
          fzffilter = 'qfz', --	enter fzf mode
        },

        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
          },
        },
      }
    end,
  },
}
