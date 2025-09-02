local hour = tonumber(os.date("%H")) -- Get the current hour (0-23)
local emoji = ""
if hour >= 6 and hour < 18 then
  emoji = "🌇  " -- Sun emoji for daytime
else
  emoji = "🌃  " -- Moon emoji for nighttime
end
vim.opt.winbar = "%=%m %f  " .. emoji
vim.o.shell = "zsh"
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
