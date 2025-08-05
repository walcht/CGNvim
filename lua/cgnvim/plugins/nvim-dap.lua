return {
  "mfussenegger/nvim-dap",
  event = { "VeryLazy" },
  lazy = false,
  config = function()
    require("cgnvim.configs.nvim-dap")
  end,
}
