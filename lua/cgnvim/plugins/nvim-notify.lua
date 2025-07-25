-- @type 
return {
  "rcarriga/nvim-notify",
  version = "*",
  lazy = false,
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = function()
    return require("cgnvim.configs.nvim-notify")
  end,
}
