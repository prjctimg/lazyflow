local autocmd = vim.api.nvim_create_autocmd
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
