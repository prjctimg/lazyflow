require("snacks")

return {

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        win = {
          position = "float",
          minimal = false,
          backdrop = 50,

          footer_pos = "center",
          footer = "💡 Press C-/ to quit/toggle",
          title_pos = "center",

          border = "vpad",
          title = "shell 🛰️",
          zindex = 70,
        },
      },
      animate = {
        easing = "inOutCirc",
        fps = 120,
        enabled = true,
      },
      explorer = {

        sort = { fields = { "sort" } },
        tree = true,
        watch = true,
        diagnostics = true,
        diagnostics_open = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        follow_file = true,
        focus = "list",
        auto_close = true,
        jump = { close = false },
        formatters = {
          file = { filename_only = true },
        },
        matcher = { sort_empty = false, fuzzy = true },
      },
      picker = {
        ui_select = true,

        sources = { explorer = { layout = { layout = { position = "float", height = 0.7, width = 0.6 } } } },
      },
      image = {
        enabled = true,
      },
      statuscolumn = {
        folds = {
          git_hl = true,

          open = true,
        },
      },
      zen = {
        show = {
          statusline = true,
        },
      },

      dashboard = {

        wo = {
          wrap = true,
        },
        sections = {

          {
            pane = 1,
            enabled = true,
            section = "terminal",
            cmd = "colorscript -e suckless | lolcat",
            align = "center",
            -- padding = 1,
          },
          { section = "keys", gap = 1 },

          {
            pane = 1,
            enabled = true,
            section = "terminal",
            cmd = "fish_greeting | pv -qL 60;sleep 4s;clear;colorscript -e square | lolcat -p 5.0 -S 120 ;exit",
            align = "center",
            -- padding = 1,
          },
        },

        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Files", action = ":lua Snacks.dashboard.pick('files')", padding = 1 },
            {
              icon = " ",
              key = "g",
              desc = "Grep",
              action = ":lua Snacks.dashboard.pick('live_grep')",
              padding = 1,
            },

            {
              icon = " ",
              key = "h",
              desc = "History",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
              padding = 1,
            },

            {
              icon = " ",
              desc = "Sessions",
              key = "w",
              padding = 1,
              action = function()
                require("persistence").select()
              end,
            },
            {
              icon = " ",
              padding = 1,
              key = "s",
              desc = "Settings",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { padding = 1, icon = " ", key = "r", desc = "Resume", section = "session" },

            { padding = 1, icon = " ", key = "x", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
