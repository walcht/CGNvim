--- @brief
---
--- Rolsyn LS config largely adapted from:
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/roslyn_ls.lua
---
--- and also from roslyn.nvim plugin:
--- https://github.com/seblyng/roslyn.nvim

--------------------------------------------------------------------------------
-- NEOVIM UNITY GLOBALS
--------------------------------------------------------------------------------

-- these globals are set by Neovim Unity plugin: com.walcht.ide.neovim upon the
-- instantiation of a Neovim server instance. These are set to themselves
-- because they are expected to be set via "nvim --cmd '<var> = <value>'" and
-- we want to keep LuaLS happy.

---@type string? this is only set in case of Unity projects
_G.nvim_unity_curr_unity_project_root_dir = nil

---@type string? an optional user-supplid project root. If this is set, then
---any opened C# files will always use this as their LS root dir (regardless
---of whether it actually is).
_G.nvim_unity_user_supplied_project_root_dir =
  _G.nvim_unity_user_supplied_project_root_dir

---@type boolean if true, textDocument/diagnostic requests completion times for
---initially opened buffers are logged and notified.
_G.nvim_unity_benchmark_roslyn_ls = _G.nvim_unity_benchmark_roslyn_ls or false

---@type "openFiles" | "fullSolution" | "none"
_G.nvim_unity_analyzer_diagnostic_scope = _G.nvim_unity_analyzer_diagnostic_scope
  or "openFiles"

---@type "openFiles" | "fullSolution" | "none"
_G.nvim_unity_compiler_diagnostic_scope = _G.nvim_unity_compiler_diagnostic_scope
  or "openFiles"

--------------------------------------------------------------------------------
-- ROSLYN LS BENCHMARKING
--------------------------------------------------------------------------------

---@type integer solution/project initialization start time in ms
local start_time

local function log_benchmarking_settings()
  local benchmark_settings = {
    ---@diagnostic disable-next-line: undefined-field
    ["os"] = vim.loop.os_uname().sysname,
    ["dotnet_analyzer_diagnostics_scope"] = _G.nvim_unity_analyzer_diagnostic_scope,
    ["dotnet_compiler_diagnostics_scope"] = _G.nvim_unity_compiler_diagnostic_scope,
  }
  local indent = vim.bo.expandtab and (" "):rep(vim.o.shiftwidth) or "\t"
  local stringified = vim.json.encode(benchmark_settings, { indent = indent })
  local msg = "[benchmark] started textDocument/diagnostic with settings: "
    .. stringified
  vim.notify(msg, vim.log.levels.INFO)
  vim.lsp.log.error(msg)
end

--------------------------------------------------------------------------------
-- MISC SHIT
--------------------------------------------------------------------------------

local fs = vim.fs

-- current solution target (can be a solution file .sln(x) or a C# file for
-- single-file projects).
local sln_target = nil

--------------------------------------------------------------------------------
-- INITIALIZATION CALLBACKS
--------------------------------------------------------------------------------

--- This will be called on LS initialization to request Roslyn to open the
--- provided solution
---
---@param client vim.lsp.Client
---@param target string absolute path to .sln[x] solution file or a single C#
---document in case of single-file projects.
---
---@return nil
local function on_init_sln(client, target)
  vim.notify("Initializing: solution" .. target, vim.log.levels.INFO)
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("solution/open", {
    solution = vim.uri_from_fname(target),
  })
end

--- This will be called on LS initialization to request Roslyn to open the
--- provided project (usually when no solution (.sln) file was found this is
--- used as a fallback).
---
---@param client vim.lsp.Client LSP client (this neovim instance)
---@param project_files string[] set of absolute paths to project files
---(.csproj) that will be requested to be opened by Roslyn LS.
---
---@return nil
local function on_init_project(client, project_files)
  vim.notify("Initializing: projects", vim.log.levels.INFO)
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("project/open", {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

--- Tries to find the solution/project root directory using the provided buffer
--- id. This is done by trying to look up the directories until finding a one
--- that contains a .sln(x) file. If that fails, this looks instead for the
--- first .csproj file it encounters. Finally, if that also fails, the absolute
--- path to this buffer is sent for single-file C# project LSP functionality.
---
---@param bufnr integer
---@param on_dir fun(root_dir?:string)
---
---@return nil
local function project_root_dir_discovery(bufnr, on_dir)
  -- if there is a user-supplied project root, then simply use it.
  if _G.nvim_unity_user_supplied_project_root_dir then
    vim.notify(
      "[C# LS] using user-supplied Unity project root dir: "
        .. _G.nvim_unity_user_supplied_project_root_dir,
      vim.log.levels.INFO
    )
    on_dir(_G.nvim_unity_user_supplied_project_root_dir)
    return
  end

  -- otherwise, we check if this C# file is part of a Unity project
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local root_dir = nil
  for dir in vim.fs.parents(bufname) do
    if vim.fn.isdirectory(vim.fs.joinpath(dir, "/Assets")) then
      root_dir = dir
      break
    end
  end

  -- this means this is part of a Unity project
  if root_dir then
    -- if there is already a currently running Unity LS session
    if _G.nvim_unity_curr_unity_project_root_dir then
      -- is the Unity session the same?
      if _G.nvim_unity_curr_unity_project_root_dir == root_dir then
        on_dir(root_dir)
        return
      -- only a single client + Roslyn LS is created/maintained
      -- throughout the whole session (as to why: performance reasons. Running
      -- a LS + client for a Unity project is usually very resource intensive).
      else
        vim.notify(
          string.format(
            "[C# LSP] you have opened a C# file that belong to different Unity "
              .. "project (%s) than the one currently in use (%s). LS support "
              .. "for this buffer is disabled.",
            root_dir,
            _G.nvim_unity_curr_unity_project_root_dir
          ),
          vim.log.levels.WARN
        )
        return
      end
    -- otherwise, this is the first time we instantiate this Unity session
    else
      _G.nvim_unity_curr_unity_project_root_dir = root_dir
      on_dir(root_dir)
      return
    end
  end

  -- at this point we are not dealing with C# file that belongs to Unity project
  -- and nor has the user manually supplied a project root

  -- try find '.sln[xf]' file (which resides in root dir)
  root_dir = vim.fs.root(bufnr, function(fname, _)
    return fname:match("%.sln[x]?$") ~= nil
  end)

  -- in case no '.sln[xf]' file was found then look for the first '.csproj'
  if not root_dir then
    root_dir = vim.fs.root(bufnr, function(fname, _)
      return fname:match("%.csproj$") ~= nil
    end)
  end

  if root_dir then
    -- this means that we have found a root (either from .sln[xf] or .csproj)
    on_dir(root_dir)
  else
    -- this means that we have NOT found a root - use single-file mode
    on_dir(bufname)
    vim.notify(
      "[C# LSP] failed to find root directory - LS is running in "
        .. "single-file mode.",
      vim.log.levels.WARN
    )
  end

  vim.notify(
    "[C# LSP] failed to find root directory - LS is disabled for this buffer.",
    vim.log.levels.WARN
  )
end

--- set Roslyn LS handlers. Each handler corresponds to a request that might be
--- sent by Roslyn LS - you can get the set of Roslyn LSP method names from:
--- https://github.com/dotnet/roslyn/tree/main/src/LanguageServer/Protocol
---
---@type table<string, function>?
local roslyn_handlers = {
  -- once Roslyn LS has finished initializing the project, we request
  -- diagnostics for the current opened buffers
  ["workspace/projectInitializationComplete"] = function(_, _, ctx)
    vim.notify("Roslyn project initialization complete", vim.log.levels.INFO)

    local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local method = vim.lsp.protocol.Methods.textDocument_diagnostic

    if _G.nvim_unity_benchmark_roslyn_ls then
      local msg = string.format(
        "[benchmark] textDocument/diagnostics request completion "
          .. "time for %i buffers",
        #buffers
      )
      -- it's set to error because any lower level and the log simply gets
      -- full of nonsense logs...
      vim.notify(msg, vim.log.levels.INFO)
      vim.lsp.log.error(msg)
    end

    for _, buf in ipairs(buffers) do
      --- @type lsp.Handler Response |lsp-handler| for this method.
      local handler = nil

      if _G.nvim_unity_benchmark_roslyn_ls then
        handler = function(_err, _res, _ctx)
          -- call the default handler
          (client.handlers[method] or vim.lsp.handlers[method])(
            _err,
            _res,
            _ctx
          )
          ---@diagnostic disable-next-line: undefined-field
          local secs, ms = vim.uv.gettimeofday()
          local diff = (secs + ms * 0.001 * 0.001) - start_time
          local msg = string.format(
            "[benchmark] textDocument/diagnostics request for bufnr %i done in: %.3fs",
            _ctx.bufnr,
            diff
          )
          vim.notify(msg, vim.log.levels.INFO)
          -- it's set to error because any lower level and the log simply gets
          -- full of nonsense logs...
          vim.lsp.log.error(msg)
        end -- end handler
      end

      local success = client:request(method, {
        textDocument = vim.lsp.util.make_text_document_params(buf),
      }, handler, buf)

      if not success then
        vim.notify(
          string.format(
            "failed to send request to Roslyn LS for textDocument_diagnostic "
              .. "for buf: %s",
            vim.api.nvim_buf_get_name(buf)
          ),
          vim.log.levels.ERROR
        )
      end
    end -- end for buf
  end,

  -- This is only kept for backwards compatibility and is no longer needed for
  -- latest Roslyn versions: https://github.com/dotnet/roslyn/pull/81233
  --
  -- this means that `dotnet restore` has to be ran on the project/solution
  -- we can do that manually or, better, request the Roslyn LS instance to do it
  -- for us using the "workspace/_roslyn_restore" request which invokes the
  -- `dotnet restore <PATH-TO-SLN>` cmd
  ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

    -- request the Roslyn LS to run dotnet restore (better than doing it
    -- ourselves).
    ---@diagnostic disable-next-line: param-type-mismatch
    client:request("workspace/_roslyn_restore", result, function(err, response)
      if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        vim.lsp.log.error(err.message)
      end
      local no_errors = true
      if response then
        for _, v in ipairs(response) do
          -- an error could be reported in the message string, if found log it
          if string.find(v.message, "error%s*MSB%d%d%d%d") then
            vim.lsp.log.warn(v.message)
            vim.notify(v.message, vim.log.levels.WARN)
            no_errors = false
          end
        end
      end
      if no_errors then
        vim.notify("dotnet restore completed successfully", vim.log.levels.INFO)
      else
        vim.notify(
          "dotnet restore completed with errors - see LSP log",
          vim.log.levels.WARN
        )
      end
    end)

    return vim.NIL
  end,

  ["workspace/_roslyn_projectHasUnresolvedDependencies"] = function()
    if sln_target ~= nil then
      vim.notify(
        string.format(
          "Detected missing dependencies. Run `dotnet restore %s` command.",
          sln_target
        ),
        vim.log.levels.ERROR
      )
      return vim.NIL
    end
    vim.notify(
      "Detected missing dependencies. Run `dotnet restore` command.",
      vim.log.levels.ERROR
    )
  end,

  -- Razor stuff that we do not care about
  ["razor/provideDynamicFileInfo"] = function(_, _, _)
    vim.notify(
      "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
      vim.log.levels.WARN
    )
  end,
}

-- Roslyn-LS-specific settings
local roslyn_ls_specific_settings = {
  ["csharp|background_analysis"] = {
    -- Option to turn configure background analysis scope for the current
    -- user. Note: setting this to "fullSolution" may result in significant
    -- performance degradation, see: https://github.com/dotnet/vscode-csharp/issues/8145#issuecomment-2784568100
    ---@type "openFiles" | "fullSolution" | "none"
    dotnet_analyzer_diagnostics_scope = _G.nvim_unity_analyzer_diagnostic_scope,

    -- Option to configure compiler diagnostics scope for the current user.
    -- Note: setting this to "fullSolution" may result in significant
    -- performance degradation, see: https://github.com/dotnet/vscode-csharp/issues/8145#issuecomment-2784568100
    ---@type "openFiles" | "fullSolution" | "none"
    dotnet_compiler_diagnostics_scope = _G.nvim_unity_compiler_diagnostic_scope,
  },
  ["csharp|inlay_hints"] = {
    ---@type boolean
    dotnet_enable_inlay_hints_for_parameters = true,
    ---@type boolean
    dotnet_enable_inlay_hints_for_literal_parameters = true,
    ---@type boolean
    dotnet_enable_inlay_hints_for_indexer_parameters = true,
    ---@type boolean
    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
    ---@type boolean
    dotnet_enable_inlay_hints_for_other_parameters = true,
    ---@type boolean
    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
    ---@type boolean
    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    ---@type boolean
    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    ---@type boolean
    csharp_enable_inlay_hints_for_types = true,
    ---@type boolean
    csharp_enable_inlay_hints_for_implicit_variable_types = true,
    ---@type boolean
    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
    ---@type boolean
    csharp_enable_inlay_hints_for_implicit_object_creation = true,
    ---@type boolean
    csharp_enable_inlay_hints_for_collection_expressions = true,
  },
  ["csharp|symbol_search"] = {
    ---@type boolean
    dotnet_search_reference_assemblies = true,
  },
  ["csharp|completion"] = {
    ---@type boolean
    dotnet_show_name_completion_suggestions = true,
    ---@type boolean
    dotnet_provide_regex_completions = true,

    -- Whether to show completion items from namespaces that are not imported.
    -- For example, if this is set to true, and you don't have the namespace
    -- `System.Net.Sockets` imported, then when you type "Sock" you will not
    -- get completion for `Socket` or other items in that namespace.
    ---@type boolean
    dotnet_show_completion_items_from_unimported_namespaces = false,

    ---@type boolean
    dotnet_trigger_completion_in_argument_lists = true,
  },
  ["csharp|code_lens"] = {
    ---@type boolean
    dotnet_enable_references_code_lens = true,
    ---@type boolean
    dotnet_enable_tests_code_lens = true,
  },
  ["csharp|projects"] = {
    -- A folder to log binlogs to when running design-time builds.
    ---@type string?
    dotnet_binary_log_path = nil,
    -- Whether or not automatic nuget restore is enabled.
    ---@type boolean
    dotnet_enable_automatic_restore = true,
    -- Whether to use the new 'dotnet run app.cs' (file-based programs)
    -- experience.
    ---@type boolean
    dotnet_enable_file_based_programs = true,
    -- Whether to use the new 'dotnet run app.cs' (file-based programs)
    -- experience in files where the editor is unable to determine with
    -- certainty whether the file is a file-based program.
    ---@type boolean
    dotnet_enable_file_based_programs_when_ambiguous = true,
  },
  ["csharp|navigation"] = {
    ---@type boolean
    dotnet_navigate_to_decompiled_sources = true,
    ---@type boolean
    dotnet_navigate_to_source_link_and_embedded_sources = true,
  },
  ["csharp|highlighting"] = {
    ---@type boolean
    dotnet_highlight_related_json_components = true,
    ---@type boolean
    dotnet_highlight_related_regex_components = true,
  },
}

local lsp_log_lvl_to_roslyn_log_lvl = {
  [vim.log.levels.OFF] = "None",
  [vim.log.levels.TRACE] = "Trace",
  [vim.log.levels.DEBUG] = "Debug",
  [vim.log.levels.INFO] = "Information",
  [vim.log.levels.WARN] = "Warning",
  [vim.log.levels.ERROR] = "Error",
}

---@type lsp.ClientCapabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.diagnostic.dynamicRegistration = true

---@type vim.lsp.Config
local roslyn_ls_config = {
  name = "roslyn_ls",
  offset_encoding = "utf-8",
  cmd = {
    -- on Windows, you can simply directly call the executable:
    --  "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.exe",
    --  <roslyn-ls-path> is a placeholder for the path to the Roslyn LS dir
    "dotnet",
    "<roslyn_ls_path>/Microsoft.CodeAnalysis.LanguageServer.dll",

    -- Critical|Debug|Error|Information|None|Trace|Warning
    "--logLevel=" .. lsp_log_lvl_to_roslyn_log_lvl[vim.lsp.log.get_level()],

    -- here we supply same log path as the one used by current LSP client
    -- (hence why we use - somewhat - the same log level)
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),

    "--stdio",
  },
  filetypes = { "cs" },
  handlers = roslyn_handlers,
  root_dir = project_root_dir_discovery,
  on_init = {
    function(client)
      local root_dir = client.config.root_dir

      if _G.nvim_unity_benchmark_roslyn_ls then
        -- vim.lsp.log.set_level(vim.log.levels.INFO)
        ---@diagnostic disable-next-line: undefined-field
        local seconds, microsecond = vim.uv.gettimeofday()
        start_time = seconds + microsecond * 0.001 * 0.001
        log_benchmarking_settings()
      end

      -- try load first solution we find
      for entry, type in fs.dir(root_dir) do
        if
          type == "file"
          and (vim.endswith(entry, ".sln") or vim.endswith(entry, ".slnx"))
        then
          on_init_sln(client, fs.joinpath(root_dir, entry))
          sln_target = entry
          return
        end
      end

      -- if no solution is found then load project
      local project_found = false
      for entry, type in vim.fs.dir(root_dir) do
        if type == "file" and vim.endswith(entry, ".csproj") then
          on_init_project(client, { vim.fs.joinpath(root_dir, entry) })
          project_found = true
        end
      end

      if not project_found then
        vim.notify(
          "[C# LSP] no solution/.csproj files were found",
          vim.log.levels.ERROR
        )
      end
    end,
  },
  capabilities = capabilities,
  settings = roslyn_ls_specific_settings,
  -- Roslyn LS is quite resource intensive... We want to be 100% sure that it
  -- is closed and not orphaned (e.g., if nvim crashes).
  detached = false,
}

return roslyn_ls_config
