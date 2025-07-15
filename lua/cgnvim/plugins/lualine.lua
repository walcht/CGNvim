return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    return require("cgnvim.configs.lualine")
  end,
}
