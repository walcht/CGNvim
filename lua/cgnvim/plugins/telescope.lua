return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    return require("cgnvim.configs.telescope")
  end,
  keys = {
    {
      "<leader>lf",
      function()
        require("telescope.builtin").find_files()
      end,
      mode = "n",
      desc = "(l)ist all (f)iles in the working directory (Telescope)",
    },
    {
      "<leader>lb",
      function()
        require("telescope.builtin").buffers()
      end,
      mode = "n",
      desc = "(l)ist all currently open (b)uffers (Telescope)",
    },
    {
      "<leader>lr",
      function()
        require("telescope.builtin").registers()
      end,
      mode = "n",
      desc = "(l)ist vim (r)egisters (Telescope)",
    },
    {
      "<leader>lk",
      function()
        require("telescope.builtin").keymaps()
      end,
      mode = "n",
      desc = "(l)ist (k)eymaps (Telescope)",
    },
    {
      "<leader>lq",
      function()
        require("telescope.builtin").quickfix()
      end,
      mode = "n",
      desc = "(l)ist (k)eymaps (Telescope)",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").live_grep()
      end,
      mode = "n",
      desc = "(f)ind in all (f)iles using ripgrep (Telescope)",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      mode = "n",
      desc = "(f)ind in current (b)uffer (Telescope)",
    },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").spell_suggest()
      end,
      mode = "n",
      desc = "(s)pell (s)uggest (Telescope)",
    },
  },
}
