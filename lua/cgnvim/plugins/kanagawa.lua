return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 5000,
  opts = function()
    return require("cgnvim.configs.kanagawa")
  end,
}
