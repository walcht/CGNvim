-- Open LSP log in a new tab
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

-- LSP information in a new tab
vim.api.nvim_create_user_command(
  "LspInfo",
  ":checkhealth vim.lsp",
  { desc = "LSP information (alias to :checkhealth vim.lsp)" }
)
