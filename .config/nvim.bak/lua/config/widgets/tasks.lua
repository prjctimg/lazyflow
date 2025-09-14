-- lua/tasks.lua

local uv = vim.loop
local fn = vim.fn
local M = {}

-- Default filepath; override via M.setup()
M.tasks_path = fn.stdpath("data") .. "/tasks.json"

-- Ensure the JSON file exists
local function ensure_file()
  local stat = uv.fs_stat(M.tasks_path)
  if not stat then
    local fd = uv.fs_open(M.tasks_path, "w", 0x1A4) -- 0644
    if fd then
      uv.fs_write(fd, "[]", 0)
      uv.fs_close(fd)
    end
  end
end

-- Load tasks from disk
function M.load_tasks()
  ensure_file()
  local raw = fn.readfile(M.tasks_path)
  local ok, data = pcall(fn.json_decode, table.concat(raw, "\n"))
  return ok and data or {}
end

-- Save tasks to disk
-- @param tasks table
-- @return boolean
function M.save_tasks(tasks)
  local encoded = fn.json_encode(tasks)
  if not encoded then
    return false
  end
  return fn.writefile({ encoded }, M.tasks_path) == 0
end

-- Add a new task with title and YYYY-MM-DD deadline
-- @return boolean
function M.add(title, deadline)
  local tasks = M.load_tasks()
  table.insert(tasks, {
    title = title,
    deadline = deadline,
    status = "pending",
  })
  return M.save_tasks(tasks)
end

-- Mark a task done by its index
-- @param idx number
-- @return boolean
function M.mark_done(idx)
  local tasks = M.load_tasks()
  if not tasks[idx] then
    return false
  end
  tasks[idx].status = "done"
  return M.save_tasks(tasks)
end

-- Return a formatted list of all tasks
-- @return string[]
function M.list()
  local out = {}
  local today = os.date("%Y-%m-%d")
  for i, t in ipairs(M.load_tasks()) do
    local mark = (t.status == "done") and "[✔]" or "[ ]"
    local due = (t.deadline < today and t.status ~= "done") and "(overdue)" or ""
    table.insert(out, string.format("%d. %s %s %s → %s", i, mark, t.title, due, t.deadline))
  end
  if #out == 0 then
    return { "No tasks found." }
  end

  Snacks.picker.select(out, { prompt = "Tasks" }, function(item, idx)
    print(item)
  end)
end

M.list()
-- Return upcoming or missed tasks for the daily report
-- @return string[]
function M.overview()
  local out = {}
  local today = os.date("%Y-%m-%d")
  for _, t in ipairs(M.load_tasks()) do
    if t.status ~= "done" then
      if t.deadline < today then
        table.insert(out, string.format("[Missed] %s (%s)", t.title, t.deadline))
      else
        table.insert(out, string.format("[Due]    %s (%s)", t.title, t.deadline))
      end
    end
  end
  if #out == 0 then
    return { "No pending tasks." }
  end
  return out
end

-- Override default filepath
-- @param opts table { filepath = ".../my_tasks.json" }
function M.setup(opts)
  if opts and opts.filepath then
    M.tasks_path = opts.filepath
  end
end

return M
