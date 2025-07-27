---@brief
---
--- from: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/roslyn_ls.lua

local uv = vim.uv
local fs = vim.fs

local project_initialization_notification = nil
local sln_target = nil

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  project_initialization_notification = vim.notify('Initializing: ' .. target, vim.log.levels.INFO, { title = 'C# LSP' })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('solution/open', {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify('Initializing: projects', vim.log.levels.INFO, { title = 'C# LSP', timeout = 10000 })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('project/open', {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

local function roslyn_handlers()
  return {
    ['workspace/projectInitializationComplete'] = function(_, _, ctx)
      vim.notify('Roslyn project initialization complete', vim.log.levels.INFO,
        { title = 'C# LSP', replace = project_initialization_notification })

      local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      for _, buf in ipairs(buffers) do
        client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
          textDocument = vim.lsp.util.make_text_document_params(buf),
        }, nil, buf)
      end
    end,
    ['workspace/_roslyn_projectHasUnresolvedDependencies'] = function()
      if sln_target ~= nil then
        vim.notify(string.format('Detected missing dependencies. Run `dotnet restore %s` command.', sln_target),
          vim.log.levels.ERROR, {
            title = 'C# LSP',
          })
        return vim.NIL
      end
      vim.notify('Detected missing dependencies. Run `dotnet restore` command.',
        vim.log.levels.ERROR, {
          title = 'C# LSP',
        })
    end,
    ['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

      ---@diagnostic disable-next-line: param-type-mismatch
      client:request('workspace/_roslyn_restore', result, function(err, response)
        if err then
          vim.notify(err.message, vim.log.levels.ERROR, { title = 'C# LSP' })
        end
        if response then
          local log_lvl = vim.log.levels.INFO
          local t = {}
          for _, v in ipairs(response) do
            t[#t + 1] = v.message
            -- an error could be reported in the message string, if found then
            -- change the log level accordingly
            if string.find(v.message, "error%s*MSB%d%d%d%d") then
              log_lvl = vim.log.levels.WARN
            end
          end
          vim.notify(table.concat(t, "\n"), log_lvl,
            { title = "C# LSP ['workspace/_roslyn_restore'] response" })
        end
      end)

      return vim.NIL
    end,
    ['razor/provideDynamicFileInfo'] = function(_, _, _)
      vim.notify(
        'Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim',
        vim.log.levels.WARN,
        { title = 'C# LSP' }
      )
    end,
  }
end

---@type vim.lsp.ClientConfig
return {
  name = 'roslyn_ls',
  offset_encoding = 'utf-8',
  cmd = {
    "dotnet",
    "/opt/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel=Error",  -- Critical|Debug|Error|Information|None|Trace|Warning
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    "--stdio",
  },
  filetypes = { 'cs' },
  handlers = roslyn_handlers(),
  root_dir = function(bufnr, cb)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- don't try to find sln or csproj for files from libraries
    -- outside of the project
    if not bufname:match('^' .. fs.joinpath('/tmp/MetadataAsSource/')) then
      -- try find solutions root first
      local root_dir = fs.root(bufnr, function(fname, _)
        return fname:match('%.sln$') ~= nil
      end)

      if not root_dir then
        -- try find projects root
        root_dir = fs.root(bufnr, function(fname, _)
          return fname:match('%.csproj$') ~= nil
        end)
      end

      if root_dir then
        cb(root_dir)
      else
        print("[C# LSP] failed to find root directory - LSP support is disabled")
      end
    end
  end,
  on_init = {
    function(client)
      local root_dir = client.config.root_dir

      -- try load first solution we find
      for entry, type in fs.dir(root_dir) do
        if type == 'file' and vim.endswith(entry, '.sln') then
          on_init_sln(client, fs.joinpath(root_dir, entry))
          sln_target = entry
          return
        end
      end

      -- if no solution is found load project
      local project_found = false
      for entry, type in fs.dir(root_dir) do
        if type == 'file' and vim.endswith(entry, '.csproj') then
          on_init_project(client, { fs.joinpath(root_dir, entry) })
          project_found = true
        end
      end

      if not project_found then
        print("[C# LSP] no solution/.csproj files were found")
      end
    end,
  },
  capabilities = {
    -- HACK: Doesn't show any diagnostics if we do not set this to true
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    ['csharp|background_analysis'] = {
      dotnet_analyzer_diagnostics_scope = 'fullSolution',
      dotnet_compiler_diagnostics_scope = 'fullSolution',
    },
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ['csharp|symbol_search'] = {
      dotnet_search_reference_assemblies = true,
    },
    ['csharp|completion'] = {
      dotnet_show_name_completion_suggestions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_provide_regex_completions = true,
    },
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
    },
  },
  on_error = function(code, err)
    vim.notify(err, vim.log.levels.ERROR, { title = "C# LSP" })
  end,
}
