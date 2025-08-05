-----------------------------------------
--- KEYMAPS
-----------------------------------------
local function dap_continue()
  require("dap").continue()
end

local function dap_step_over()
  require("dap").step_over()
end

local function dap_step_into()
  require("dap").step_into()
end

local function dap_step_out()
  require("dap").step_out()
end

local function dap_toggle_breakpoint()
  require("dap").toggle_breakpoint()
end

vim.keymap.set("n", "<F5>", dap_continue, { desc = "debugger continue/start (VSCode-like keymap)" })
vim.keymap.set("n", "<leader>dc", dap_continue, { desc = "(d)ebugger (c)ontinue/start" })

vim.keymap.set("n", "<F10>", dap_step_over, { desc = "debugger step over (VSCode-like keymap)" })
vim.keymap.set("n", "<leader>do", dap_step_over, { desc = "(d)ebugger step (o)ver" })

vim.keymap.set("n", "<F11>", dap_step_into, { desc = "debugger step into (VSCode-like keymap)" })
vim.keymap.set("n", "<leader>di", dap_step_into, { desc = "(d)ebugger step (i)nto" })

vim.keymap.set("n", "<F12>", dap_step_out, { desc = "debugger step out (VSCode-like keymap)" })
vim.keymap.set("n", "<leader>dO", dap_step_out, { desc = "(d)ebugger step (O)ut" })

vim.keymap.set("n", "<leader>db", dap_toggle_breakpoint, { desc = "toggle (d)ebug (b)reakpoint" })

-----------------------------------------
--- SIGN DEFINES
-----------------------------------------
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "󰇽", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "󱂅", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "debugPC", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "WarningMsg", linehl = "", numhl = "" })
