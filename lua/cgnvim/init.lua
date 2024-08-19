vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none",
    "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
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
  install = { colorscheme = { "material-deep-ocean" } },
  checker = { enabled = false },
})

vim.cmd "colorscheme material-deep-ocean"

if vim.loader then vim.loader.enable() end
for _, source in ipairs {
  "cgnvim.gsettings",
  "cgnvim.gmappings",
  "cgnvim.gautocmds",
} do
  local status_ok, error_object = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load: " .. source
      .. "\n\n" .. error_object)
  end
end
