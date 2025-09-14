-- return {
--   { "mason-org/mason.nvim", version = "1.11.0" },
--   { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
-- }
--
--
return {

  {
    "barrett-ruth/live-server.nvim",
    build = "sudo npm i -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
}
