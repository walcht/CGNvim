local function custom_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  local m = vim.keymap.set

  -- consistent with LSP/other plugins
  m("n", "K", api.node.show_info_popup, opts("Info"))
  m("n", "<CR>", api.node.open.edit, opts("Open"))
  m("n", "t<CR>", api.node.open.tab, opts("Open: new (t)ab"))
  m("n", "v<CR>", api.node.open.vertical, opts("Open: (v)ertical split"))
  m("n", "h<CR>", api.node.open.horizontal, opts("Open: (h)orizontal split"))
  m("n", "<Tab>", api.node.open.preview, opts("Open: preview"))
  m("n", "<BS>", api.node.navigate.parent_close, opts("Close directory"))
  m("n", ">", api.node.navigate.sibling.next, opts("Next sibling"))
  m("n", "<", api.node.navigate.sibling.prev, opts("Previous sibling"))
  m("n", ".", api.node.run.cmd, opts("Run command"))
  m("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
  m("n", "a", api.fs.create, opts("File: (a)ppend/create"))
  m("n", "c", api.fs.copy.node, opts("File: (c)opy content"))
  m("n", "r", api.fs.rename, opts("File: (r)ename"))
  m("n", "d", api.fs.remove, opts("File: (d)elete"))
  m("n", "y", api.fs.copy.filename, opts("File: (y)ank name"))
  m("n", "Y", api.fs.copy.absolute_path, opts("File: (Y)ank absolute path"))
  m("n", "E", api.tree.expand_all, opts("(E)xpand all"))
  m("n", "W", api.tree.collapse_all, opts("Collapse all (W next to E)"))
  m("n", "<C-n>", api.node.navigate.diagnostics.next, opts("(n)ext diagnostic"))
  m("n", "<C-p>", api.node.navigate.diagnostics.prev, opts("(p)rev diagnostic"))
  m("n", "f", api.live_filter.start, opts("(f)ilter"))
  m("n", "F", api.live_filter.clear, opts("Clean (F)ilter"))
  m("n", "<leader>tg", api.tree.toggle_gitignore_filter, opts("(t)oggle (g)itignore"))
  m("n", "H", api.tree.toggle_hidden_filter, opts("Show/(H)ide dotfiles"))
  m("n", "m", api.marks.toggle, opts("(m)ark/un(m)ark"))
  m("n", "o", api.node.open.edit, opts("(o)pen"))
  m("n", "O", api.node.open.no_window_picker, opts("(O)pen: no window picker"))
  m("n", "P", api.node.navigate.parent, opts("(P)arent directory"))
  m("n", "R", api.tree.reload, opts("(R)efresh"))
  m("n", "s", api.node.run.system, opts("Run (s)ystem"))
  m("n", "S", api.tree.search_node, opts("(S)earch"))
  m("n", "U", api.tree.toggle_custom_filter, opts("Toggle hidden"))
  m("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
  m("n", "q", api.tree.close, opts("(q)uit"))
  m("n", "g?", api.tree.toggle_help, opts("Help"))
end

return {
  view = {
    width = 40,
    side = "right",
  },
  diagnostics = {
    show_on_open_dirs = true,
  },
  filters = {
    custom = { "*.meta", "*.csproj", "*.cache", "*.dll*" },
  },
  git = {
    -- increase timeout because of Git LFS
    timeout = 4000,
  },
  -- custom keymaps
  on_attach = custom_on_attach,
}
