require("snacks")
return {

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      animate = {
        easing = "inOutCirc",
        fps = 120,
        enabled = true,
      },
      explorer = {

        sort = { fields = { "sort" } },
        supports_live = true,
        tree = true,
        watch = true,
        diagnostics = true,
        diagnostics_open = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        follow_file = true,
        focus = "list",
        auto_close = false,
        jump = { close = false },
        -- to show the explorer to the right, add the below to
        -- your config under `opts.picker.sources.explorer`
        -- layout = { layout = { position = "right" } },
        formatters = {
          file = { filename_only = true },
        },
        matcher = { sort_empty = false, fuzzy = true },

        -- config = function(opts)
        --   return require("snacks.picker.source.explorer").setup(opts)
        -- end,
      },
      picker = {
        ui_select = true,

        sources = { explorer = { layout = { layout = { position = "right" } } } },
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
        sections = {
          { section = "header" },

          { section = "keys" },
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
              desc = "Workspaces",
              key = "w",
              padding = 1,
              action = ":lua Snacks.dashboard.pick('projects')",
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

          header = [[           ディーン・タリサイ 🌃          ]],
        },
      },
    },
  },
}
