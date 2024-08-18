return {
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = function()
    return require "cgnvim.configs.telescope"
  end,
}
