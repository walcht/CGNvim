return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup(require("cgnvim.configs.nvim-treesitter"))
  end,
}
