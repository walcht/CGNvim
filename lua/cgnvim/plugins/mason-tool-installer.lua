return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  dependencies = { "williamboman/mason.nvim" },
  opts = function()
    return require("cgnvim.configs.mason-tool-installer")
  end,
}
