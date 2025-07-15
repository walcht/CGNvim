local M = {}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")


-- add your LSP language configs here
M.setup = function()
  -----------------------------------------------------------------------------
  ------------------------------- lua_ls (lua) --------------------------------
  -----------------------------------------------------------------------------
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. '/.luarc.json') or
          vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        return
      end
      client.config.settings.Lua = vim.tbl_deep_extend(
        'force',
        client.config.settings.Lua,
        {
          runtime = {
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
            }
          }
        })
    end,
    settings = {
      Lua = {}
    }
  }

  -----------------------------------------------------------------------------
  ------------------------------- clangd (C++) --------------------------------
  -----------------------------------------------------------------------------
  lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = { "clangd" }
  }

  -----------------------------------------------------------------------------
  ----------------------------- pyright (Python) ------------------------------
  -----------------------------------------------------------------------------

  lspconfig.pyright.setup {
    capabilities = capabilities,
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
  }

  -----------------------------------------------------------------------------
  -------------------------- glsl_analyzer (glsl) -----------------------------
  -----------------------------------------------------------------------------

  lspconfig.glsl_analyzer.setup {
    capabilities = capabilities,
    cmd = { "glsl_analyzer" },
    filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
  }

  -----------------------------------------------------------------------------
  ------------------------------ bashls (bash) --------------------------------
  -----------------------------------------------------------------------------

  lspconfig.bashls.setup {
    capabilities = capabilities,
    cmd = { "bash-language-server", "start" },
  }

  -----------------------------------------------------------------------------
  ------------------------------ cmake (cmake) --------------------------------
  -----------------------------------------------------------------------------

  lspconfig.cmake.setup {
    capabilities = capabilities,
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
  }

  -----------------------------------------------------------------------------
  ------------------------------- Omnisharp (C#) ------------------------------
  -----------------------------------------------------------------------------

  lspconfig.omnisharp.setup {
    capabilities = capabilities,
    -- handlers = {
    --     ["textDocument/definition"] = require('omnisharp_extended').handler,
    -- },
    cmd = {
      "omnisharp",
      '--languageserver',
      '--hostPID',
      tostring(vim.fn.getpid())
    },
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = false,
        EnableImportCompletion = false,
        EnableDecompilationSupport = true,
      },
    }
  }
end

return M
