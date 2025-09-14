local PrintNotifier = {}
local clear_timer = function()
  vim.defer_fn(function()
    vim.cmd("TimerHide -1")
  end, 2000)
end
local function notify(msg)
  Snacks.notify(msg, { style = "fancy", title = "", icon = "🕰️" })
end

PrintNotifier.new = function(timer, opts)
  local self = setmetatable({}, { __index = PrintNotifier })
  self.timer = timer
  self.hidden = false
  self.opts = opts -- not used
  return self
end

PrintNotifier.start = function(self)
  notify(string.format("%s, for %d mins", self.timer.name, self.timer.time_limit / 60))
  clear_timer()
end

PrintNotifier.tick = function(self, time_left)
  -- if not self.hidden then
  --   notify(string.format("%s, %ds remaining ⏳...", self.timer.name, time_left))
  -- end
  -- clear_timer()
end

PrintNotifier.done = function(self)
  notify(string.format(" %s complete ✅", self.timer.name))
  clear_timer()
end

PrintNotifier.stop = function(self) end

PrintNotifier.show = function(self)
  self.hidden = false
end

PrintNotifier.hide = function(self)
  self.hidden = true
end
return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = false,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {

    notifiers = { {
      init = PrintNotifier.new,
      opts = {},
    } },

    update_interval = 1000,
    sticky = false,
    sessions = {
      pomodoro = {
        { name = "Preflight Check 🧑‍✈", duration = "2m" },
        { name = "Work 🧑‍💻", duration = "30m" },
        { name = "Short Break 🪑", duration = "5m" },
        { name = "Work 🧑‍💻", duration = "25m" },
        { name = "Long Break 🏖", duration = "15m" },
      },

      check = {
        { name = "Preflight Check 🧑‍✈", duration = "5m" },
      },
    },
  },
}
