require("snacks")
local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {

  once = true,
  callback = function()
    local now = (os.date("*t")) -- Get the current hour (0-23)
    local hour = now.hour
    local light_theme = "tokyonight-day"
    local dark_theme = "tokyonight"
    local is_day = hour >= 6 and hour < 17
    local emoji = ""
    if hour >= 6 and hour < 18 then
      emoji = "🌇  "
    else
      emoji = "🌃  "
    end
    local username = vim.fn.system("whoami"):gsub("[\n\r]", "")
    vim.opt.winbar = "%=%m %f  " .. emoji
    local theme_delay = 0
    -- Change the theme based on time of day.
    local function theme_switch()
      -- The amount of seconds in an hour
      local hour_seconds = 3600
      local sunrise_time = 6 * hour_seconds
      local sunset_time = 17 * hour_seconds
      local function ms_to_hms()
        local total_seconds = math.floor(theme_delay / 1000)
        local hours = math.floor(total_seconds / 3600)
        local minutes = math.floor((total_seconds % 3600) / 60)
        local seconds = (total_seconds % 3600) % 60

        local parts = {}

        if hours > 0 then
          local label = "hr"
          if hours > 1 then
            label = "hrs"
          end
          table.insert(parts, string.format("%d%s", hours, label))
        end

        if minutes > 0 then
          local label = "min"
          if minutes > 1 then
            label = "mins"
          end
          table.insert(parts, string.format("%d%s", minutes, label))
        end

        table.insert(parts, string.format("%ds", seconds))

        if #parts == 0 then
          return "just a moment"
        elseif #parts == 1 then
          return parts[1]
        elseif #parts == 2 then
          return parts[1] .. " & " .. parts[2]
        else
          local last_part = table.remove(parts)
          return table.concat(parts, ", ") .. " & " .. last_part
        end
      end
      local day_seconds = hour * hour_seconds + now.min * 60 + now.sec
      if is_day then
        vim.cmd.colorscheme(light_theme)
        theme_delay = (sunset_time - day_seconds) * 1000
        Snacks.notifier(ms_to_hms() .. " till dark 🌔", "info", {
          title = "Lights on",
          style = "fancy",
          icon = "🌄",
        })
      else
        if day_seconds >= sunset_time then
          theme_delay = (24 * hour_seconds - day_seconds + sunrise_time) * 1000
        else
          theme_delay = (sunrise_time - day_seconds) * 1000
        end
        vim.cmd.colorscheme(dark_theme)
        Snacks.notifier(ms_to_hms() .. " till dawn 🌅", "info", {
          icon = "🎑",
          title = "Lights out",
          style = "fancy",
        })
      end
    end

    local function greeter()
      local res

      if hour >= 5 and hour < 12 then
        res = "Morning, " .. username .. " ☀️"
      elseif hour >= 12 and hour < 17 then
        res = "Afternoon, " .. username .. " 🌤️"
      elseif hour >= 17 and hour < 21 then
        res = "Evening, " .. username .. " 🌆"
      else
        res = "Burning the midnight oil, " .. username .. "? 🌙"
      end

      Snacks.notify(res, {
        title = "",
        icon = "👋",
        level = "info",
        timeout = 4000,
      })
    end
    vim.defer_fn(greeter, 6000)

    theme_switch()
    vim.fn.timer_start(theme_delay, theme_switch, { ["repeat"] = -1 })
    vim.defer_fn(function()
      vim.cmd("TimerSession check")
    end, 30000)
  end,
})
