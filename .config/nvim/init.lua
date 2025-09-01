-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.snacks")
require("lualine").setup({
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
})

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}
vim.lsp.enable("fish_lsp")
local hour = tonumber(os.date("%H")) -- Get the current hour (0-23)
local light_theme = "tokyonight-day"
local dark_theme = "tokyonight"
local is_day = hour >= 6 and hour < 17

if is_day then
  vim.cmd.colorscheme(light_theme)
  Snacks.notifier("Lights on 🌞", "info", {
    title = "",
    style = "fancy",
    icon = "🌄",
  })
else
  vim.cmd.colorscheme(dark_theme)
  Snacks.notifier("Lights out 🌘", "info", {
    icon = "🎑",
    title = "",
    style = "fancy",
  })
end

-- vim.fn.timer_start(60000, function()
--   if is_day then
--     vim.cmd.colorscheme(light_theme)
--   else
--     vim.cmd.colorscheme(dark_theme)
--   end
-- end, { ["repeat"] = -1 })
vim.defer_fn(function()
  vim.cmd("TimerSession check")
end, 4000)
