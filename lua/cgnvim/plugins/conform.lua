return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "fb",
      function()
        require("conform").format({ async = true })
      end,
      mode = "n",
      desc = "(f)ormat (b)uffer using language formatter if available",
    },
    {
      "<C-I>",
      function()
        require("conform").format({ async = true })
      end,
      mode = "n",
      desc = "format current buffer using language formatter if available",
    },
    {
      "<C-k><C-d>",
      function()
        require("conform").format({ async = true })
      end,
      mode = "n",
      desc = "format current buffer using language formatter if available",
    },
  },
  opts = function()
    return require("cgnvim.configs.conform")
  end,
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
