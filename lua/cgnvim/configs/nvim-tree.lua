local function custom_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return {
      desc = desc .. " (Explorer)",
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  local m = vim.keymap.set

  -- consistent with LSP/other plugins
  m("n", "K", api.node.show_info_popup, opts("show metadata (K)nowledge"))
  m("n", "<CR>", api.node.open.edit, opts("open into new buffer"))
  m("n", "v<CR>", api.node.open.vertical, opts("open (v)ertically"))
  m("n", "h<CR>", api.node.open.horizontal, opts("open (h)orizontally"))
  m("n", "<Tab>", api.node.open.preview, opts("preview file/expand directory"))
  m("n", ".", api.node.run.cmd, opts("run command on current(.) entry"))
  m("n", "a", api.fs.create, opts("(a)ppend/create file/directory"))
  m("n", "c", api.fs.copy.node, opts("(c)opy file content"))
  m("n", "r", api.fs.rename, opts("(r)ename file/directory"))
  m("n", "d", api.fs.remove, opts("(d)elete file/directory"))
  m("n", "y", api.fs.copy.filename, opts("(y)ank basename to system clipboard"))
  m("n", "Y", api.fs.copy.absolute_path, opts("(Y)ank file/directory absolute path"))
  m("n", "E", api.tree.expand_all, opts("(E)xpand all"))
  m("n", "W", api.tree.collapse_all, opts("collapse all (W next to E)"))
  m("n", "]d", api.node.navigate.diagnostics.next, opts("next(] on the right) diagnostic"))
  m("n", "[d", api.node.navigate.diagnostics.prev, opts("rev([ on the left) diagnostic"))
  m("n", "f", api.live_filter.start, opts("(f)ilter"))
  m("n", "F", api.live_filter.clear, opts("clean (F)ilter"))
  m("n", "<leader>tg", api.tree.toggle_gitignore_filter, opts("(t)oggle (g)itignore filter"))
  m("n", "<leader>td", api.tree.toggle_hidden_filter, opts("(t)oggle (d)otfiles filter"))
  m("n", "<leader>tc", api.tree.toggle_custom_filter, opts("(t)oggle (c)ustom filter"))
  m("n", "<leader>tb", api.tree.toggle_no_buffer_filter, opts("(t)oggle (b)uffer filter"))
  m("n", "m", api.marks.toggle, opts("(m)ark/un(m)ark"))
  m("n", "P", api.node.navigate.parent, opts("(P)arent directory"))
  m("n", "R", api.tree.reload, opts("(R)efresh"))
  m("n", "e", api.node.run.system, opts("(e)xecute system"))
  m("n", "<2-LeftMouse>", api.node.open.edit, opts("open into new buffer"))
  m("n", "q", api.tree.close, opts("(q)uit"))
  m("n", "g?", api.tree.toggle_help, opts("show help(?) window"))
end

return {
  disable_netrw = true,
  respect_buf_cwd = true,
  view = {
    width = 40,
    side = "right",
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = true,
    debounce_delay = 500,
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    custom = { "*.meta", "*.csproj", "*.cache", "*.dll*" },
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false,
  },
  git = {
    -- increase timeout because of Git LFS
    timeout = 4000,
  },
  -- custom keymaps
  on_attach = custom_on_attach,
  renderer = {
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = {
      enable = false,
      ignore_list = {},
    },
    exclude = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      eject = true,
      resize_window = true,
      relative_path = true,
    },
  },
}
