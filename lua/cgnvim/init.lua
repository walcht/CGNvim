---@diagnostic disable: undefined-field
-- keep this at the top
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------
-- LAZYNVIM PLUGIN MANAGER
-----------------------------
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  spec = {
    { import = "cgnvim.plugins" },
  },
  install = { colorscheme = { "kanagawa-dragon" } },
  checker = { enabled = false },
  ui = {
    border = "single",
  },
})
if vim.loader then
  vim.loader.enable()
end

-----------------------------
-- DEFAULT COLOR SCHEME
-----------------------------
vim.cmd([[colorscheme kanagawa-dragon]])

-----------------------------
-- GLOBAL SETTINGS
-----------------------------
for _, source in ipairs({
  "cgnvim.gsettings",
  "cgnvim.gmappings",
  "cgnvim.gautocmds",
  "cgnvim.gusercmds",
}) do
  local status_ok, error_object = pcall(require, source)
  if not status_ok then
    vim.notify("failed to load: " .. source .. "\n\n" .. error_object, vim.log.levels.ERROR)
  end
end

-----------------------------
-- LSPs INITIALIZATION
-----------------------------
-- default (i.e., inherited by all) LSP config
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  root_markers = { ".git" },
  on_error = function(code, err)
    vim.notify(vim.lsp.rpc.client_errors[code] .. err, vim.log.levels.ERROR)
  end,
})
-- enable virtual lines and disable virtual text diagnostics
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})
-- enable inlay hints
vim.lsp.inlay_hint.enable(true)
-- add LSPs to ignore here (same name as in ./lsps/ folder without the .lua extension)
local lsp_ignore = {}
-- load LSPs defined in ./lsps/ folder
local p = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "cgnvim", "lsps")
for lsp_name, _ in vim.fs.dir(p) do
  local status_ok, error_object = pcall(function()
    local lsp_id = lsp_name:gsub("%.lua", "")
    if lsp_ignore[lsp_id] == nil then
      local lsp_config = require("cgnvim.lsps." .. lsp_id)
      vim.lsp.config(lsp_id, lsp_config)
      vim.lsp.enable(lsp_id)
    end
  end)
  if not status_ok then
    vim.notify("failed to load LSP: " .. lsp_name .. "\n\n" .. "Reason: " .. error_object, vim.log.levels.ERROR)
  end
end

-----------------------------
-- DAPs INITIALIZATION
-----------------------------
-- load DAPs defined in ./daps/ folder
for da, _ in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "cgnvim", "daps")) do
  local status_ok, error_object = pcall(require, "cgnvim.daps." .. da:gsub("%.lua", ""))
  if not status_ok then
    vim.notify("failed to load DAP: " .. da .. "\n\n" .. "Reason: " .. error_object, vim.log.levels.ERROR)
  end
end
