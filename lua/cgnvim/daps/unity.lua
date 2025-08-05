--[[DAP configuration that allows Neovim DAP client to attach to a running
Unity Player instance.]]

local dap = require("dap")

dap.adapters.unity = {
  type = "executable",
  -- adjust mono path - Unity installations integrate it by default
  command = "/home/walcht/Unity/Hub/Editor/6000.1.14f1/Editor/Data/MonoBleedingEdge/bin/mono",
  -- adjust UnityDebug.exe path
  args = { "/home/walcht/Downloads/unity-debug/extension/bin/UnityDebug.exe" },
}

-- make sure not to override other C# DAP configs
if dap.configurations.cs == nil then
  dap.configurations.cs = {}
end

-- Tries to find the project root path and returns an absolute path to EditorInstance.json
-- @return string?
local function try_find_editor_instance_json_path()
  local path = vim.fn.expand("%:p")
  while true do
    local new_path = vim.fn.fnamemodify(path, ":h")
    if new_path == path then
      return ""
    end
    path = new_path
    local assets = vim.fn.glob(path .. "/Library")
    if assets ~= "" then
      local p = vim.fs.joinpath(path, "Library/EditorInstance.json")
      return p
    end
  end
end

table.insert(dap.configurations.cs, {
  name = "Unity Editor",
  type = "unity",
  request = "attach",

  -- options passed to UnityDebug.exe

  path = try_find_editor_instance_json_path,
})

-- { "arguments" = { "adapterID" = "nvim-dap", "clientID" = "neovim", "clientName" = "neovim", "columnsStartAt1" = true, "linesStartAt1" = true, "locale" = "en_US.UTF-8", "pathFormat" = "path", "supportsProgressReporting" = true, "supportsRunInTerminalRequest" = true, "supportsStartDebuggingRequest" = true, "supportsVariableType" = true }, "command" = "initialize", "seq" = 1, "type" = "request" }
