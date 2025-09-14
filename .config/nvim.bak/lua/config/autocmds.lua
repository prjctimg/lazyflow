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
