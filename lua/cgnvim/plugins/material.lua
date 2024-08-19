return {
    'marko-cerovac/material.nvim',
  lazy = false,
  priority = 10000,
  opts = function()
    return require("cgnvim.configs.material")
  end,
}
