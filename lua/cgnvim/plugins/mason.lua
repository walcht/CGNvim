return {
  "williamboman/mason.nvim",
  lazy = false,
  -- make sure to keep this loading order
  --    1. mason.nvim
  --    2. mason-lspconfig.nvim
  --    3. nvim-lspconfig
  priority = 2000,
  opts = function()
    return require("cgnvim.configs.mason")
  end,
}
