-- default (i.e., inherited by all) LSP config
vim.lsp.config("*",
{
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    root_markers = {".git"},
})

-- C# LSP (comment both lines to disable)
vim.lsp.config("roslyn_ls", require("cgnvim.lsps.roslyn_ls"))
vim.lsp.enable("roslyn_ls")


-- C/C++ LSP (comment both lines to disable)
vim.lsp.config("clangd", require("cgnvim.lsps.clangd"))
vim.lsp.enable("clangd")

-- Lua LSP (comment both lines to disable)
vim.lsp.config("lua_ls", require("cgnvim.lsps.lua_ls"))
vim.lsp.enable("lua_ls")
