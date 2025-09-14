local autocmd = vim.api.nvim_create_autocmd
local augrp = vim.api.nvim_create_augroup

autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ async = true, bufnr = args.buf })
  end,
})

-- Fish scripting setup. Start LSP and detect if shebang is targeting fish
-- if it is, then switch the filetype to fish as well (respectively)
autocmd("FileType", {
  pattern = "*.fish",
  callback = function()
    vim.lsp.start({
      name = "fish-lsp",
      cmd = { "fish-lsp", "start" },
      cmd_env = { fish_lsp_show_client_popups = true },
    })
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = augrp("FishShebangDetect", { clear = true }),
  pattern = "*.sh", -- Target all files ending in .sh
  callback = function(args)
    local bufnr = args.buf

    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""

    if string.match(first_line, "^#!.*[/ ]fish") then
      vim.bo[bufnr].filetype = "fish"
    end
  end,
})
-- LSP symbols outline split view automatically triggered when a configured LSP is attached
autocmd("LspAttach", {

  callback = function()
    local outline = require("outline")
    local is_active = outline.is_open()
    if is_active then
      outline.refresh_outline()
      return
    end
    return outline.open({
      focus_outline = false,
    })
  end,
  once = true,
})
-- LSP signature help/hover auto pop up
autocmd("LspAttach", {

  callback = function(args)
    -- Change this variable to change how long it takes to trigger the signature help popup
    local popup_delay_ms = 4000
    local sig_timer = nil
    local ts = vim.treesitter
    -- Cache
    local last_symbol, last_sig_ok, last_hover_ok = nil, nil, nil
    local function lsp_popup_visible()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if ft == "markdown" or ft == "plaintext" then
            return true
          end
        end
      end
      return false
    end

    -- Get symbol identity (type + name) under cursor
    local function get_symbol_identity()
      local ok, parser = pcall(ts.get_parser, 0)
      if not ok or not parser then
        return nil
      end
      local tree = parser:parse()[1]
      if not tree then
        return nil
      end
      local root = tree:root()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1
      local node = root:named_descendant_for_range(row, col, row, col)
      local trigger_nodes = {
        "function_name",
        "function",
        "variable",
        "identifier",
        "method_invocation",
        "function_call",
        "call_expression",
      }
      if not node then
        return nil
      end

      while node do
        local t = node:type()
        if vim.tbl_contains(trigger_nodes, t) then
          local name = ts.get_node_text(node, 0)
          return t .. ":" .. (name or "")
        end
        node = node:parent()
      end
      return nil
    end

    -- Generic LSP feature request with availability check
    local function request_lsp_feature(method, check_fn, callback)
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients == 0 then
        return
      end
      local client = clients[1]
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

      vim.lsp.buf_request(bufnr, method, params, function(err, result)
        if check_fn(err, result) then
          callback()
        end
      end)
    end

    -- Checkers for signature help and hover
    local function has_signature(err, result)
      return not err and result and result.signatures and #result.signatures > 0
    end

    local function has_hover(err, result)
      if err or not result or not result.contents then
        return false
      end
      if type(result.contents) == "string" then
        return result.contents ~= ""
      elseif type(result.contents) == "table" then
        return not vim.tbl_isempty(result.contents)
      end
      return false
    end

    -- Show popup without stealing focus
    local function show_signature()
      vim.lsp.buf.signature_help({
        focusable = false,
        focus_id = "lsp_signature_help",
        title = "💡",
      })
    end

    local function show_hover()
      vim.lsp.buf.hover({
        focusable = false,
        focus_id = "lsp_hover",

        title = "💡",
      })
    end

    -- Main timer logic
    local function reset_lsp_help_timer()
      if vim.fn.mode() ~= "n" then
        return
      end
      if sig_timer then
        sig_timer:stop()
        sig_timer:close()
        sig_timer = nil
      end

      sig_timer = vim.loop.new_timer()
      sig_timer:start(
        popup_delay_ms,
        0,
        vim.schedule_wrap(function()
          if lsp_popup_visible() then
            return
          end

          local symbol_id = get_symbol_identity()
          if symbol_id and symbol_id == last_symbol then
            if last_sig_ok then
              show_signature()
            elseif last_hover_ok then
              show_hover()
            end
            return
          end

          last_symbol, last_sig_ok, last_hover_ok = symbol_id, false, false

          if symbol_id then
            request_lsp_feature("textDocument/signatureHelp", has_signature, function()
              last_sig_ok = true
              show_signature()
            end)

            request_lsp_feature("textDocument/hover", has_hover, function()
              last_hover_ok = true
              if not last_sig_ok then
                show_hover()
              end
            end)
          else
            request_lsp_feature("textDocument/hover", has_hover, function()
              last_hover_ok = true
              show_hover()
            end)
          end
        end)
      )
    end

    local bufnr = args.buf
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local supports = false
    for _, client in ipairs(clients) do
      if client.server_capabilities.signatureHelpProvider or client.server_capabilities.hoverProvider then
        supports = true
        break
      end
    end
    if not supports then
      return
    end

    local lsp_auto_help = augrp("LspAutoHelp_" .. bufnr, { clear = true })

    autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = lsp_auto_help,
      buffer = bufnr,
      callback = reset_lsp_help_timer,
    })

    autocmd("BufLeave", {
      group = lsp_auto_help,
      buffer = bufnr,
      callback = function()
        last_symbol, last_sig_ok, last_hover_ok = nil, nil, nil
      end,
    })
  end,
})
