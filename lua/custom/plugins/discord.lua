local blacklist = {
  '.dotfiles',
  'dotfiles',
  'nvim',
}

local is_blacklisted = function(opts)
  return vim.tbl_contains(blacklist, opts.workspace)
end
local git_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')

return {
  {
    'vyfor/cord.nvim',
    enabled = false,
    config = function()
      local quotes = {
        -- 'GTA VI came out before my Rust program finished compiling. ⏳',
        'When your code works on the first try. 😱',
        'It’s not a bug, it’s a feature. 🐛✨',
        'I don’t always test my code, but when I do, I do it in production. 💥',
        'My code works, I have no idea why. 🤷‍♂️',
        'Hello from the other side... of a merge conflict. 🔀',
        'If it works, don’t touch it. 🛑',
        -- 'May your code never compile on the first try. 🤞',
      }
      require('cord').setup {
        enabled = true,
        log_level = vim.log.levels.OFF,
        editor = {
          client = 'neovim',
          tooltip = 'Entering monk mode',
          icon = '⛩️',
        },
        display = {
          theme = 'default',
          flavor = 'dark',
          swap_fields = false,
          swap_icons = false,
        },
        timestamp = {
          enabled = true,
          reset_on_idle = false,
          reset_on_change = false,
        },
        idle = {
          enabled = false,
          timeout = 300000,
          show_status = true,
          ignore_focus = true,
          unidle_on_focus = true,
          smart_idle = false,
          details = 'Idling',
          state = nil,
          tooltip = '💤',
          icon = nil,
        },
        text = {
          workspace = function(opts)
            return 'In ' .. opts.workspace
          end,
          viewing = function(opts)
            return 'Viewing ' .. opts.filename
          end,
          editing = function(opts)
            return 'Editing ' .. opts.filename
          end,
          -- editing = function(opts)
          --   return string.format('Editing %s - on branch %s', opts.filename, opts.git_status)
          -- end,
          file_browser = function(opts)
            return 'Browsing files in ' .. opts.name
          end,
          plugin_manager = function(opts)
            return 'Managing plugins in ' .. opts.name
          end,
          lsp = function(opts)
            return 'Configuring LSP in ' .. opts.name
          end,
          docs = function(opts)
            return 'Reading ' .. opts.name
          end,
          vcs = function(opts)
            return 'Committing changes in ' .. opts.name
          end,
          notes = function(opts)
            return 'Taking notes in ' .. opts.name
          end,
          debug = function(opts)
            return 'Debugging in ' .. opts.name
          end,
          test = function(opts)
            return 'Testing in ' .. opts.name
          end,
          diagnostics = function(opts)
            return 'Fixing problems in ' .. opts.name
          end,
          games = function(opts)
            return 'Playing ' .. opts.name
          end,
          terminal = function(opts)
            return 'Running commands in ' .. opts.name
          end,
          dashboard = 'Home',
        },
        -- buttons = nil,
        buttons = {
          {
            label = 'View Repository',
            url = function(opts)
              return opts.repo_url
            end,
          },
        },
        assets = nil,

        variables = {
          git_status = function(opts)
            return git_branch()
          end,
        },

        hooks = {
          ready = nil,
          shutdown = nil,
          pre_activity = nil,
          post_activity = function(_, activity)
            -- activity.details = quotes[math.random(#quotes)]
          end,
          idle_enter = nil,
          idle_leave = nil,
          workspace_change = function(opts)
            if is_blacklisted(opts) then
              opts.manager:hide()
            else
              opts.manager:resume()
              git_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
            end
          end,
        },
        plugins = nil,
        advanced = {
          plugin = {
            autocmds = true,
            cursor_update = 'on_hold',
            match_in_mappings = true,
          },
          server = {
            update = 'fetch',
            pipe_path = nil,
            executable_path = nil,
            timeout = 300000,
          },
          discord = {
            reconnect = {
              enabled = false,
              interval = 5000,
              initial = true,
            },
          },
        },
      }
    end,
  },
}
