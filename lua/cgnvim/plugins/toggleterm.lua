return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm" },
  keys = {
    {
      "<leader>tt",
      "<cmd>ToggleTerm<CR>",
      mode = "n",
      desc = "(t)oggle (t)erminal",
    },
  },
  opts = function()
    return require("cgnvim.configs.toggleterm")
  end,
}
