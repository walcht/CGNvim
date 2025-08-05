local dap = require("dap")

--- @return string|nil
local function get_python_path()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  elseif vim.fn.executable("python3") == 1 then
    return "python3"
  elseif vim.fn.executable("/usr/bin/python3") == 1 then
    return "/usr/bin/python3"
  else
    --- @type string
    local chosen_path
    vim.ui.input({ prompt = "provide absolute path to Python (to run debugpy): " }, function(result)
      chosen_path = result
    end)
    if vim.fn.executable(chosen_path) then
      return chosen_path
    else
      vim.notify("you have provided an invalid Python path", vim.log.levels.ERROR)
      return nil
    end
  end
end

dap.adapters.python = function(cb, _)
  local python_path = get_python_path()
  cb({
    type = "executable",
    -- to directly provide a python path, replace the python_path with "your-path-to-python",
    command = python_path,
    args = { "-m", "debugpy.adapter" },
    options = {
      source_filetype = "python",
    },
  })
end
dap.adapters.debugpy = dap.adapters.python

-- make sure not to override other C# DAP configs
if dap.configurations.python == nil then
  dap.configurations.python = {}
end

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Launch file",

  -- options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings

  program = "${file}", -- This configuration will launch the current file if used.
  pythonPath = get_python_path(),
})
