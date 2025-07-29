return {
  "folke/trouble.nvim",
  opts = function()
    return require("cgnvim.configs.trouble")
  end,
  cmd = "Trouble",
  keys = {
    {
      "<leader>gd",
      "<cmd>Trouble diagnostics toggle<cr>",
      mode = "n",
      desc = "(g)lobal (d)iagnostics (Trouble)",
    },
    {
      "<leader>bd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      mode = "n",
      desc = "(b)uffer (d)iagnostics (Trouble)",
    },
    {
      "<leader>sym",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      mode = "n",
      desc = "(sym)bols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      mode = "n",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      mode = "n",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>ql",
      "<cmd>Trouble qflist toggle<cr>",
      mode = "n",
      desc = "(q)uickfix (l)ist (Trouble)",
    },
  },
}
