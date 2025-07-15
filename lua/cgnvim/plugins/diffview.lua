return {
  "sindrets/diffview.nvim",
  lazy = true,
  cmd = {"DiffviewOpen"},
  opts = function()
    return require("cgnvim.configs.diffview")
  end,
}
