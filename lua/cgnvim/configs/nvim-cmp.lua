local cmp = require("cmp")

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

return {
  formatting = {
    format = function(entry, vim_item)
      -- kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      -- source
      vim_item.menu = ({
        buffer = "[BUFFER]",
        nvim_lsp = "[LSP]",
        luasnip = "[SNIPPET]",
        nvim_lua = "[LUA]",
        latex_symbols = "[LATEX]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(), -- go (n)ext
    ["<C-p>"] = cmp.mapping.select_prev_item(), -- go (p)revious
    ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- go (u)p
    ["<C-d>"] = cmp.mapping.scroll_docs(4), -- go (d)own
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(), -- (e)xit
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback) -- go next
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback) -- go previous
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
}
