return {
  "mrded/nvim-lsp-notify",
  version = "*",
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'rcarriga/nvim-notify' },
  opts = function()
    return require("cgnvim.configs.nvim-lsp-notify")
  end,
}
