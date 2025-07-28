return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  opts = function()
    return require("cgnvim.configs.nvim-cmp")
  end,
}
