return {
  "lewis6991/gitsigns.nvim",
  main = "gitsigns",
  lazy = false,
  version = "*",
  opts = function()
    return require("cgnvim.configs.gitsigns")
  end,
}
