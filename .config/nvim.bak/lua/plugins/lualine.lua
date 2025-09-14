return {
  {

    {
      "nvim-lualine/lualine.nvim",
      options = {
        {
          sections = {
            lualine_z = {
              function()
                local ok, pomo = pcall(require, "pomo")
                if not ok then
                  return ""
                end

                local timer = pomo.get_first_to_finish()
                if timer == nil then
                  return ""
                end

                return "󰄉 " .. tostring(timer)
              end,
            },
            lualine_y = {
              "os.date('%a %d %b |%H:%M:%S|')",
              "progress",
            },
          },
        },
      },
    },
  },
}
