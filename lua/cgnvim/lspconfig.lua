--[[This file points to Language Server Protocol (LSP) configurations. If you
want to enable/disable an LSP or add a new one then you have to:

  1. create an LSP configuration for your lsp at ./lsps/<lsp-name>.lua
    (usually, LSP configs are copied from:
    https://github.com/neovim/nvim-lspconfig/tree/master/lsp)

  2. and add these two lua lines here:

    vim.lsp.config("<lsp-name>", require("cgnvim.lsps.<lsp-name>"))
    vim.lsp.enable("<lsp-name>")

]]

-- default (i.e., inherited by all) LSP config
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  root_markers = { ".git" },
  on_error = function(code, err)
    vim.notify(
      vim.lsp.rpc.client_errors[code] .. err,
      vim.log.levels.ERROR,
      { title = "C# LSP" }
    )
  end,
})

-- enable virtual text and disable virtual line diagnostics
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
})

-- enable inlay hints
vim.lsp.inlay_hint.enable(true)

-- C# LSP (comment both lines to disable)
vim.lsp.config("roslyn_ls", require("cgnvim.lsps.roslyn_ls"))
vim.lsp.enable("roslyn_ls")

-- C/C++ LSP (comment both lines to disable)
vim.lsp.config("clangd", require("cgnvim.lsps.clangd"))
vim.lsp.enable("clangd")

-- Lua LSP (comment both lines to disable)
vim.lsp.config("lua_ls", require("cgnvim.lsps.lua_ls"))
vim.lsp.enable("lua_ls")
