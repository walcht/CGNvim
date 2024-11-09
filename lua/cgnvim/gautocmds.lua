-------------------------------------------------------------------------------
--------------------------------- NVIM-TREE -----------------------------------
-------------------------------------------------------------------------------

-- Open nvim-tree on directory or no-name buffer
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(args)
    local is_dir = vim.fn.isdirectory(args.file) == 1
    local is_no_name = args.file == "" and vim.bo[args.buf].buftype == ""
    if is_dir then
      vim.cmd.cd(args.file)
      require("nvim-tree.api").tree.open()
      return
    end
    if is_no_name then
      require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
    end
  end
})

-------------------------------------------------------------------------------
------------------------------------ LSP --------------------------------------
-------------------------------------------------------------------------------

-- Use telelscope to go-to definitions/implementations since it provides
-- a nice interface in case of multiples definitions/implementations
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(args)
    local m = vim.keymap.set
    local _ = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { noremap = true, silent = true }
    -- TODO: only add mappings after checking server capabilities
    m("n", "gi", ":Telescope lsp_implementations<CR>", opts)
    m("n", "gd", ":Telescope lsp_definitions<CR>", opts)
    m("n", "gD", ":Telescope lsp_definitions<CR>", opts)
    m("n", "gr", ":Telescope lsp_references<CR>", opts)
    m("n", "K", vim.lsp.buf.hover, opts)
    -- (e)xplain
    m("n", "<leader>e", vim.diagnostic.open_float, opts)
    -- (q)uick (f)ix
    m("n", "<leader>qf", vim.diagnostic.setqflist, opts)
    -- (c)ode (a)ction
    m("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    -- (f)ormat (f)ile (or selection in visual mode)
    m("n", "<leader>ff", vim.lsp.buf.format, {
      noremap = true, desc = "Format File"
    })
    -- (t)oggle (l)anguage (s)erver
    m("n", "<leader>tls", function()
      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({ bufnr = buf })
      if not vim.tbl_isempty(clients) then
        vim.cmd("LspStop")
      else
        vim.cmd("LspStart")
      end
    end, { noremap = false, desc = "Toggle LSP" })
  end
})

-------------------------------------------------------------------------------
--------------------------------- ToggleTerm ----------------------------------
-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    local opts = { buffer = 0 }
    local m = vim.keymap.set
    m('t', '<esc>', [[<C-\><C-n>]], opts)
    m('t', 'jk', [[<C-\><C-n>]], opts)
    m('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    m('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    m('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    m('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    m('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end
})
