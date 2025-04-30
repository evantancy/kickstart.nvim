return {
    {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
    winopts = {
      preview = {
        layout = "horizontal",
        default = 'bat',
        title = true
      },
    },
    files = {
      -- formatter = "path.filename_first", -- places file name first
      cwd_prompt = false,
      path_shorten = true
    },
    grep = {
        rg_glob_fn = function(query, opts)
            local regex, flags = query:match(string.format('^(.*)%s(.*)$', opts.glob_separator))
            -- Return the original query if there's no separator.
            return (regex or query), flags
        end,
        prompt            = 'Rg❯ ',
        input_prompt      = 'Grep For❯ ',
        multiprocess      = true,           -- run command in a separate process
        git_icons         = false,          -- show git icons?
        file_icons        = true,           -- show file icons (true|"devicons"|"mini")?
        color_icons       = true,           -- colorize file|git icons
    },
},

    config = function(_, opts)
      local fzf = require("fzf-lua")
      -- fzf.setup({'fzf-native', opts})
      -- Create a new config table with "fzf-native" as the first element
      local config = {"fzf-native"}

      -- Copy all options from opts into the config table
      for k, v in pairs(opts) do
        config[k] = v
      end

      -- Pass the combined config to setup
      fzf.setup(config)
      fzf.register_ui_select()
      local actions = require("fzf-lua.actions")

      vim.keymap.set('n', '<leader>fg', fzf.live_grep, { silent = true, desc = 'Find with Rg' })
      vim.keymap.set('n', '<leader>fb', fzf.buffers,   { silent = true, desc = 'Search Buffers' })
      vim.keymap.set('n', '<leader>ff', fzf.files,     { silent = true, desc = 'Search Files' })
      vim.keymap.set('n', '<leader>fr', fzf.oldfiles,  { silent = true, desc = 'Search Recent MRU' })
      vim.keymap.set('n', '<leader>fR', fzf.resume,    { silent = true, desc = 'Resume' })
      vim.keymap.set('n', '<leader>fh', fzf.helptags,    { silent = true, desc = 'Find help tags' })

      local keyset={}
      local n=0

      for k,v in pairs(fzf) do
        if not k:match("^_") then
          n=n+1
          keyset[n]=k
        end
      end
      table.sort(keyset)

      vim.keymap.set({'n'}, '<leader>F', function()
        fzf.fzf_exec(keyset, {
          prompt = 'FZF...> ',
          actions = {
            ["default"] = function(selected, opts)
              fzf[selected[1]]()
            end
          }
        })
      end, { silent = true, desc = 'Search ...' })

    end
}
}

