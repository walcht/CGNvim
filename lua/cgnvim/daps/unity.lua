---@diagnostic disable: undefined-field
--[[DAP configuration that allows Neovim DAP client to attach to a running
Unity Player instance.]]

local dap = require("dap")

local function try_get_unity_editor_ip_port()
  local port = ""
  local ip = ""
  ---@type string?
  local editor_log_fp = nil

  if vim.loop.os_uname().sysname == "Linux" then
    editor_log_fp = vim.fn.expand("~/.config/unity3d/Editor.log")
  elseif vim.uv.os_uname().version:match("Windows") then
    local LOCALAPPDATA = os.getenv("LOCALAPPDATA")
    if LOCALAPPDATA ~= nil then
      editor_log_fp = vim.fn.resolve(LOCALAPPDATA .. "/Unity/Editor/Editor.log")
    end
  else
    editor_log_fp = vim.fn.expand("~/Library/Logs/Unity/Editor.log")
  end

  -- this means that currently no Unity Editor instance is running
  if editor_log_fp == nil or not vim.fn.filereadable(editor_log_fp) then
    return ip, port
  end

  -- we are looking for a line like this:
  -- Using monoOptions --debugger-agent=transport=dt_socket,embedding=1,server=y,suspend=n,address=127.0.0.1:56183
  for l in io.lines(editor_log_fp) do
    local _ip, _port = string.match(l, "^Using monoOptions.*address=(%d+%.%d+%.%d+%.%d+):(%d%d%d%d%d)")
    if _ip ~= nil and _port ~= nil then
      ip = _ip
      port = _port
      break
    end
  end

  return ip, port
end

dap.adapters.unity = function(cb, config)
  local cb_arg = {
    type = "executable",
    -- adjust unity-debug-adapter.exe path (don't forget to `chmod +x` it)
    -- get Unity debug adapter from: https://github.com/walcht/unity-dap
    command = "unity-debug-adapter.exe",
    args = {
      -- optional log level argument: trace | debug | info | warn | error | critical | none
      "--log-level=warn",
      -- optional path to log file (logs to stderr in case this is not provided)
      -- "--log-file=<path_to_log_file_txt>",
    },
  }
  if config.port ~= nil and config.address ~= nil then
    cb(cb_arg)
    return
  end

  -- when connecting to a running Unity Editor, the TCP address of the listening connection is
  -- usually localhost (i.e., 127.0.0.1)
  vim.ui.input({ prompt = "address [127.0.0.1]: ", default = "127.0.0.1" }, function(result)
    config.address = result
  end)

  vim.ui.input({ prompt = "port [56---]: " }, function(result)
    config.port = tonumber(result)
  end)

  cb(cb_arg)
end

-- make sure not to override other C# DAP configurations
if dap.configurations.cs == nil then
  dap.configurations.cs = {}
end

table.insert(dap.configurations.cs, {
  name = "Automatically connect to Unity Editor instance",
  type = "unity",
  request = "attach",
  address = function()
    local ip, _ = try_get_unity_editor_ip_port()
    return ip
  end,
  port = function()
    local _, port = try_get_unity_editor_ip_port()
    return port
  end,
})

table.insert(dap.configurations.cs, {
  name = "Manually enter IP:PORT for Unity Editor/Player instance [Mono]",
  type = "unity",
  request = "attach",
})
