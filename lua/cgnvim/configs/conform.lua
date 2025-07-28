return {
  -- add new formatters here (also add them in ./mason-tool-installer.lua for automatic installation by Mason)
  formatters_by_ft = {
    lua = { "stylua", stop_after_first = true },
    csharp = { "csharpier", stop_after_first = true },
    python = { "isort", "ruff", stop_after_first = false },
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = { timeout_ms = 500 },
}
