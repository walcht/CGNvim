--[[This file defines global Vim autocmds (i.e., not related to any particular
plugin - hence the g in this file's name)]]

local m = vim.keymap.set

-----------------------------
-- NVIM-TREE
-----------------------------
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
      require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
    end
  end,
})

-----------------------------
-- LSP
-----------------------------
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(args)
    local _ = vim.lsp.get_client_by_id(args.data.client_id)

    -- TODO: only add mappings after checking server capabilities

    -- (g)o (i)mplementations
    m("n", "gi", vim.lsp.buf.implementation, {
      noremap = true,
      desc = "(g)o (i)mplementations of symbol under cursor using LSP",
    })

    -- (g)o (d)efinition
    m("n", "gd", vim.lsp.buf.definition, {
      noremap = true,
      desc = "(g)o (d)efinition of symbol under cursor using LSP",
    })

    -- (g)o (D)eclaration
    m("n", "gD", vim.lsp.buf.declaration, {
      noremap = true,
      desc = "(g)o (D)eclaration of symbol under cursor using LSP",
    })

    -- (g)o (r)eferences
    m("n", "gr", vim.lsp.buf.references, {
      noremap = true,
      desc = "(g)o (r)references of symbol under cursor using LSP",
    })

    -- hover information of symbol under cursor
    m("n", "K", function()
      vim.lsp.buf.hover({ border = "single" })
    end, {
      noremap = true,
      desc = "hover information about symbol under cursor using LSP",
    })

    -- toggle (i)nlay (h)ints
    m("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { noremap = true, desc = "toggle (i)nlay (h)ints" })

    -- TODO: (t)oggle (c)ode (l)enses

    -- (c)ode (a)ction
    m("n", "<leader>ca", vim.lsp.buf.code_action, {
      noremap = true,
      desc = "list (c)ode (a)ctions available for symbol under cursor using LSP",
    })

    -- (r)ename (s)ymbol
    m("n", "<leader>rs", vim.lsp.buf.rename, {
      noremap = true,
      desc = "(r)ename (s)ymbol under the cursor and all of its references using LSP",
    })
  end,
})

-------------------------------------------------------------------------------
--------------------------------- ToggleTerm ----------------------------------
-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    m("t", "<esc>", [[<C-\><C-n>]], { buffer = 0 })
    m("t", "jk", [[<C-\><C-n>]], { buffer = 0 })
    m("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0 })
    m("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0 })
    m("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0 })
    m("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0 })
    m("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
  end,
})
