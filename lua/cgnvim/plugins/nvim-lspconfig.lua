return {
  "neovim/nvim-lspconfig",
  lazy = false,
  -- make sure to keep this loading order
  --    1. mason.nvim
  --    2. mason-lspconfig.nvim
  --    3. nvim-lspconfig
  priority = 500,
  config = function()
    return require("cgnvim.configs.nvim-lspconfig").setup()
  end,
}
