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
require("which-key").setup({
  preset = "helix",
  wo = {
    winblend = 80, -- value between 0-100 0 for fully opaque and 100 for fully transparent
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
local emoji = ""
if hour >= 6 and hour < 18 then
  emoji = "🌇  " -- Sun emoji for daytime
else
  emoji = "🌃  " -- Moon emoji for nighttime
end

vim.opt.winbar = "%=%m %f  " .. emoji
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
  local greeting

  if hour >= 5 and hour < 12 then
    greeting = "Morning, Dean ☀️"
  elseif hour >= 12 and hour < 17 then
    greeting = "Afternoon, Dean 🌤️"
  elseif hour >= 17 and hour < 21 then
    greeting = "Evening, Dean 🌆"
  else
    greeting = "Burning the midnight oil, Dean? 🌙"
  end

  -- Send the greeting as a notification
  Snacks.notify(greeting, {
    title = "",
    icon = "👋",
    level = "info", -- could be "warn", "error", etc.
    timeout = 4000, -- milliseconds before auto-hide
  })
end, 6000)

vim.defer_fn(function()
  vim.cmd("TimerSession check")
end, 30000)
-- Time-based greeting using snacks.notify

-- Call it immediately (or hook into an event)
