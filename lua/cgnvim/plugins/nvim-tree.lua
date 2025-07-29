return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    return require("cgnvim.configs.nvim-tree")
  end,
  keys = {
    {
      "<leader>ex",
      "<cmd>NvimTreeToggle<CR>",
      mode = "n",
      desc = "toggle file (ex)plorer",
    },
  },
}
