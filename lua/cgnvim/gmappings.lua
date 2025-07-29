--[[This file contains global (not buffer-local) mappings (hence the g in this
file's name). For buffer-dependent mappings (i.e., mappings that are only valid
within certain buffers) see: lua/cgnvim/configs/]]

local m = vim.keymap.set

-- Leader key remapping to <Space>
m("", "<Space>", "<Nop>", { noremap = true, silent = true, desc = "leader key" })

-----------------------------
-- NORMAL MODE
-----------------------------
m("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "move to left(h) window" })
m("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "move to down(j) window" })
m("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "move to up(k) window" })
m("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "move to right(l) window" })
m("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true, desc = "resize window size upwards" })
m("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true, desc = "resize window size downwards" })
m("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true, desc = "resize window leftwards" })
m("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true, desc = "resize window rightwards" })
m("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "navigate to left(l) buffer" })
m("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "navigate to right(r) buffer" })
-- move text vertically
m("n", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
m("n", "<A-k>", "<Esc>:m .-3<CR>==gi", { noremap = true, silent = true })
m("n", "J", "mzJ`z", { noremap = true, silent = true, desc = "append line below to current line" })
m("n", "<C-d>", "<C-d>zz")
m("n", "<C-u>", "<C-u>zz")
-- m("n", "n", "nzzzv", { noremap = true, silent = false, desc = "append line below to current line" })
-- m("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "append line below to current line" })
m("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "(r)eplace (w)ord" })
m("n", "Q", "<nop>") -- disable annoying keys
m("n", '"', "<nop>") -- disable annoying keys

-----------------------------
-- VISUAL MODE
-----------------------------
m("v", "<", "<gv", { noremap = true, silent = true })
m("v", ">", ">gv", { noremap = true, silent = true })
m("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected line(s) down(J)" })
m("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected line(s) up(K)" })

-----------------------------
-- VISUAL BLOCK MODE
-----------------------------
m("x", "J", ":move '>+1<CR>gv-gv", { desc = "move selected line(s) down(J)" })
m("x", "K", ":move '<-2<CR>gv-gv", { desc = "move selected line(s) up(K)" })
m("x", "<A-j>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
m("x", "<A-k>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
-- avoid bad vim paste behaviour
m("x", "<leader>p", '"_dP')

-----------------------------
-- MISC MODES
-----------------------------
m({ "n", "v", "x" }, "<leader>tr", ":set invrelativenumber<CR>", { desc = "(t)oggle (r)elative line numbering" })
m({ "n", "v", "x" }, "<leader>ts", ":set spell!<CR>", { desc = "(t)oggle (s)pell" })
m({ "n", "v", "x" }, "<leader>d", '"_d', { desc = "(d)elete to void register (without copying)" })
m({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "(y)ank to system clipboard" })
m({ "n", "v", "x" }, "<leader>Y", '"+Y', { desc = "(Y)ank to system clipboard" })
