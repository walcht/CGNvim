return {
  "williamboman/mason.nvim",
  lazy = false,
  priority = 2000,
  opts = function()
    return require("cgnvim.configs.mason")
  end,
}
