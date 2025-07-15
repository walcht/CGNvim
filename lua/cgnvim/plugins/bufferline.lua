return {
  'akinsho/bufferline.nvim',
  lazy = false,
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = function()
    return require("cgnvim.configs.bufferline")
  end,
}
