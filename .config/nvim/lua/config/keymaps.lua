require("telescope").load_extension("pomodori")
local map = function(mode, key, cb)
  vim.keymap.set(mode, key, cb, { noremap = true, silent = true })
end
map("n", "<leader>pt", function()
  require("telescope").extensions.pomodori.timers()
end)

-- Function to create a mapping that starts visual mode and moves the cursor
local function v_mv(key)
  return function()
    if vim.o.selection == "inclusive" then
      vim.cmd("normal! v" .. key)
    else
      vim.cmd("normal! V" .. key) -- Use blockwise  visual mode for 'exclusive'
    end
  end
end
map("n", ";", ":")
map("i", "<C-;>", "<ESC>:")
-- Better copy and paste behaviour
map({ "n", "i", "v", "x" }, "<C-v>", function()
  Snacks.picker.yanky({
    title = "Stuff you've yanked/deleted 📋",
  })
end)
map({ "n", "i", "v" }, "<C-c>", "<cmd>y<cr>")
map({ "n", "i", "v" }, "<C-a>", "<ESC>gg0v$G$")

-- Keymaps for Shift + Arrow keys to select text and start visual mode

map({ "n", "i", "v", "t", "x", "o" }, "<S-Left>", v_mv("h"))
map({ "n", "i", "v", "t", "x", "o" }, "<S-Up>", v_mv("k"))
map({ "n", "i", "v", "t", "x", "o" }, "<S-Down>", v_mv("j"))
map({ "n", "i", "v", "t", "x", "o" }, "<S-Right>", v_mv("l"))

-- Also includes pickers that I often use
map({ "i", "n", "v", "t", "x", "o" }, "<C-]>", "<cmd>bnext<CR>")
map({ "i", "n", "v", "t", "x", "o" }, "<C-[>", "<cmd>bprevious<CR>")

map({ "i", "n", "t", "x", "o" }, "<A-k>", function()
  return vim.lsp.buf.hover() or vim.lsp.buf.signature_help()
end)

map({ "i", "n", "t", "x", "o" }, "<A-q>", function()
  require("persistence").select()
end)
map({ "i", "n", "v", "t", "x", "o" }, "<A-.>", function()
  -- require("telescope").extensions.pomodori.timers()

  Snacks.input.input({
    prompt = "What needs to be done ?",

    icon = "🚧",
  }, function(task)
    if task == nil then
      task = "🧑‍💻"
    end
    Snacks.picker.select({ 15, 30, 45, 60, 90, 120 }, {
      prompt = "How long will it take ? ⏲️",
      format_item = function(t)
        return t .. " mins"
      end,
    }, function(item)
      if item == nil then
        item = 5
      end

      vim.cmd("TimerStart " .. item .. "mins" .. " ⏳")

      Snacks.notify.info("🧑‍💻", {
        icon = "🧑‍💻",
        title = "New task ✨",
        once = true,
        style = "fancy",
        msg = task .. "\nSession ends in " .. item .. " mins",
      })
    end)
  end)
end)

map({ "i", "n", "v", "t", "x", "o" }, "<A-,>", "<cmd>lua Snacks.scratch.open()<CR>")
map(
  {

    "i",
    "n",
    "v",
    "t",
    "x",
    "o",
  },
  "<A-f>",
  function()
    local files = require("mini.files")
    return files.close() or files.open()
  end
)
map(
  {

    "i",
    "n",
    "v",
    "t",
    "x",
    "o",
  },
  "<A-s>",
  function()
    Snacks.picker.lsp_symbols({
      title = "Symbols in this space are...🌃",
    })
  end
)

map({ "i", "n" }, "<A-S>", function()
  Snacks.picker.lsp_workspace_symbols({
    title = "Symbols in this space are...🌃",
  })
end)

map({ "i", "n", "v", "t", "x", "o" }, "<A-/>", function()
  Snacks.picker.grep({
    title = "I'm looking for this pattern...🔍",
  })
end)
map({ "i", "n", "v", "o" }, "<A-h>", function()
  Snacks.picker.help({
    title = "Read The F*cking Manual📜",
    supports_live = true,
  })
end)
map({ "i", "n", "v", "o" }, "<A-m>", function()
  Snacks.picker.man({
    title = "Read The F*cking Manual📜",
    supports_live = true,
  })
end)

map({ "i", "n" }, "<A-w>", function()
  local dirs, project_dirs = { "/home/prjctimg/sources/", "/home/prjctimg/workspace/" }, {}

  for _, dir in ipairs(dirs) do
    local cur_dir = vim.fn.globpath(dir, "*", false, true)
    for _, v in pairs(cur_dir) do
      if vim.fn.isdirectory(v) == 1 then
        table.insert(project_dirs, v)
      end
    end
  end
  Snacks.picker.projects({
    title = "On this machine 💽",
    projects = project_dirs,
  })
end)

map({ "i", "n" }, "<A-x>", function()
  Snacks.picker.diagnostics_buffer({
    title = "Where's the bug 🐛",
  })
end)

map({ "i", "n" }, "<A-X>", function()
  Snacks.picker.diagnostics({
    title = "Where's the bug 🐛",
  })
end)

map({ "i", "n" }, "<A-t>", function()
  Snacks.picker.todo_comments({
    title = "Chores🧹 and errands 🛻",
  })
end)

map({ "n", "i", "v", "t", "x", "o" }, "<esc>", "<esc><esc>")
map({ "i", "n" }, "<A-l>", function()
  Snacks.picker.lines({
    title = "I'm looking for...🔍",
  })
end)

map({ "i", "n", "v", "x", "o", "t" }, "<A-->", function()
  return vim.cmd.colorscheme("tokyonight-moon")
    and Snacks.notifier("Lights out 🌘", "info", {
      icon = "🎑",
      title = "",
      style = "fancy",
    })
end)

map({ "i", "n", "v", "x", "o", "t" }, "<A-=>", function()
  return vim.cmd.colorscheme("tokyonight-day")
    and Snacks.notifier("Lights on 🌞", "info", {
      title = "",
      style = "fancy",
      icon = "🌄",
    })
end)

map({ "i", "n" }, "<A-g>", function()
  local grug, ext, name = require("grug-far"), vim.bo.buftype == "" and vim.fn.expand("%:e"), "grug"
  if grug.has_instance(name) then
    grug.hide_instance(name)
  else
    grug.open({
      transient = true,
      prefills = {
        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
      },
      instanceName = "grug",
    })
  end
end)

map({ "i", "n" }, "<A-A>", function()
  Snacks.picker.autocmds()
end)

map({ "i", "n" }, "<A-p>", "<cmd>put<CR>")
map({ "i", "n" }, "<A-a>", function()
  vim.lsp.buf.code_action()
end)

map({ "i", "n" }, "<A-i>", function()
  Snacks.picker.lsp_implementations()
end)

map({ "i", "n" }, "<C-f>", function()
  vim.lsp.buf.format()
end)
map({ "i", "n" }, "<C-O>", function()
  vim.lsp.buf.add_workspace_folder()
end)
map({ "i", "n" }, "<A-r>", function()
  vim.lsp.buf.rename()
end)
map({ "i", "n" }, "<A-d>", function()
  Snacks.picker.lsp_definitions()
end)

map({ "i", "n", "v", "t" }, "<A-u>", function()
  Snacks.picker.undo({
    title = "The last changes were...⏲️",
  })
end)

map({ "i", "n", "v", "t" }, "<A-o>", "<cmd>Outline<cr>")
map({ "i", "n", "v" }, "<A-b>", function()
  Snacks.picker.buffers({
    title = "Active tabs 📂",
  })
end)

-- map({ "i", "n" }, "<A-k>", function()
--   Snacks.picker.keymaps()
-- end)
map({ "i", "n" }, "<A-j>", function()
  Snacks.picker.jumps({
    title = "Jump back to... 🦘",
  })
end)
map({ "i", "n", "t", "x", "o", "v" }, "<A-`>", function()
  require("telescope").load_extension("emoji").emoji()
end)
map({ "i", "n" }, "<A-z>", function()
  Snacks.dashboard.open()
end)
