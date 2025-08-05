return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
  opts = function()
    return require("cgnvim.configs.nvim-treesitter")
  end,
}
