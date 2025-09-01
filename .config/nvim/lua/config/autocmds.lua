local autocmd = vim.api.nvim_create_autocmd
local augrpcmd = vim.api.nvim_create_augroup
autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

autocmd("FileType", {
  pattern = "fish",
  callback = function()
    vim.lsp.start({
      name = "fish-lsp",
      cmd = { "fish-lsp", "start" },
      cmd_env = { fish_lsp_show_client_popups = true },
    })
  end,
})

-- Autocommand to detect fish shebang in .sh files and set the filetype accordingly.
-- This allows fish-lsp (and other fish-specific settings) to activate.

-- Create a dedicated augroup to ensure the autocmd can be cleared and reloaded cleanly.
-- This prevents the autocmd from being duplicated if you source your config multiple times.
local fishShebangGroup = augrpcmd("FishShebangDetect", { clear = true })

-- Create the autocommand that triggers when opening or reading a .sh file.
autocmd({ "BufRead", "BufNewFile" }, {
  group = fishShebangGroup,
  pattern = "*.sh", -- Target all files ending in .sh
  desc = "Detect fish shebang in .sh files and set filetype to fish",
  callback = function(args)
    local bufnr = args.buf

    -- Read the first line of the buffer.
    -- vim.api.nvim_buf_get_lines returns a table of lines, so we take the first item.
    -- We add 'or ""' to prevent errors on an empty file.
    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""

    -- Use a string pattern to check if the first line is a shebang pointing to fish.
    -- This pattern is flexible and will match:
    -- #!/usr/bin/fish
    -- #!/usr/bin/env fish
    -- #!/bin/fish
    -- etc.
    if string.match(first_line, "^#!.*[/ ]fish") then
      -- If a match is found, set the filetype for the current buffer to 'fish'.
      -- Neovim's built-in mechanisms, including lspconfig, will now treat this
      -- as a fish file, attaching the language server and applying syntax highlighting.
      vim.bo[bufnr].filetype = "fish"

      Snacks.notify.info("Fish shell shebang detection for .sh files loaded.")
    end
  end,
})

autocmd({ "BufEnter" }, {

  pattern = { "*.js", "*.ts", "*.zig", "*.jsx", "*.tsx", "*.lua", "*.fish", "*.sh", "*.css", "*.css" },
  command = ":Outline!",
  -- callback = function(args)
  --   local outline = require("outline")
  --   local is_open = outline:toggle_outline()
  --   local has_provider = outline:has_provider()
  --   if not has_provider then
  --     outline:close_outline()
  --   end
  --   if is_open then
  --     outline.follow_cursor({
  --       focus_outline = false,
  --
  --     })
  --   end
  -- end,
  once = true,
})

-- autocmd({ "BufEnter", "CursorHold" }, {
--   group = my_autocmds_group,
--
--   callback = (function()
--     local last_pos = nil
--     return function()
--       local pos = vim.api.nvim_win_get_cursor(0)
--       if last_pos and last_pos[1] == pos[1] and last_pos[2] == pos[2] then
--         return
--       end
--       last_pos = { pos[1], pos[2] }
--       vim.defer_fn(function()
--         vim.lsp.buf.hover({
--
--           focusable = false,
--           focus = false,
--         })
--       end, 300000)
--     end
--   end)(),
--
--   desc = "Show symbol help signature on CursorHold",
--   -- vim.diagnostic.show_line_diagnostics()
--   pattern = { "*.lua", "*.ts", "*.js", "*.go", "*.zig" },
-- })
