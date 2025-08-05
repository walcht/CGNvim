return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  event = { "VeryLazy" },
  lazy = false,
  opts = function()
    return require("cgnvim.configs.nvim-dap-ui")
  end,
}
