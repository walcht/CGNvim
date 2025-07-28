return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm" },
  opts = function()
    return require("cgnvim.configs.toggleterm")
  end,
}
