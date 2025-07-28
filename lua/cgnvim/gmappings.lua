--[[This file contains global (not buffer-local) mappings (hence the g in this
file's name). For buffer-dependent mappings (i.e., mappings that are only valid
within certain buffers) see: lua/cgnvim/configs/]]

local opts = { noremap = true, silent = true }
local m = vim.keymap.set

-- Leader key remapping to <Space>
m("", "<Space>", "<Nop>", opts)

-------------------------------------------------------------------------------
-------------------------------- NORMAL MODE ----------------------------------
-------------------------------------------------------------------------------

-- window navigation
m("n", "<C-h>", "<C-w>h", opts)
m("n", "<C-j>", "<C-w>j", opts)
m("n", "<C-k>", "<C-w>k", opts)
m("n", "<C-l>", "<C-w>l", opts)
-- window resizing using arrow keys
m("n", "<C-Up>", ":resize +2<CR>", opts)
m("n", "<C-Down>", ":resize -2<CR>", opts)
m("n", "<C-Left>", ":vertical resize -2<CR>", opts)
m("n", "<C-Right>", ":vertical resize +2<CR>", opts)
-- navigate to left/right buffer
m("n", "<S-l>", ":bnext<CR>", opts)
m("n", "<S-h>", ":bprevious<CR>", opts)
-- move text vertically
m("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
m("n", "<A-k>", "<Esc>:m .-3<CR>==gi", opts)
m("n", "J", "mzJ`z")
m("n", "<C-d>", "<C-d>zz")
m("n", "<C-u>", "<C-u>zz")
m("n", "n", "nzzzv")
m("n", "N", "Nzzzv")
-- disable annoying keys
m("n", "Q", "<nop>")
m("n", '"', "<nop>")
-- (r)eplace (w)ord
m("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- nvim-tree
m("n", "<leader>ex", ":NvimTreeToggle<CR>", opts)
-- telescope
m("n", "<leader>ff", ":Telescope find_files<CR>", opts)
m("n", "<leader>fb", ":Telescope buffers<CR>", opts)
m("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
m("n", "<leader>ss", ":Telescope spell_suggest<CR>", opts)
-- (t)oggle (t)erminal
m("n", "<leader>tt", ":ToggleTerm<CR>", opts)

-------------------------------------------------------------------------------
-------------------------------- VISUAL MODE ----------------------------------
-------------------------------------------------------------------------------

-- stay in indent mode
m("v", "<", "<gv", opts)
m("v", ">", ">gv", opts)
-- move text up and down and adjust indents accordingly
m("v", "J", ":m '>+1<CR>gv=gv")
m("v", "K", ":m '<-2<CR>gv=gv")

-------------------------------------------------------------------------------
----------------------------- VISUAL BLOCK MODE -------------------------------
-------------------------------------------------------------------------------

-- move text up and down
m("x", "J", ":move '>+1<CR>gv-gv", opts)
m("x", "K", ":move '<-2<CR>gv-gv", opts)
m("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
m("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
-- avoid bad vim paste behaviour
m("x", "<leader>p", '"_dP')

-------------------------------------------------------------------------------
--------------------------------- TERMINAL ------------------------------------
-------------------------------------------------------------------------------

m("t", "<ESC>", "<C-\\><C-n>", opts)

-------------------------------------------------------------------------------
------------------------------- DIAGNOSTICS -----------------------------------
------------------------------------------------------------------------------

-------------------------------------------------------------------------------
----------------------------------- MISC --------------------------------------
-------------------------------------------------------------------------------

-- (t)oggle (r)elative line numbers
m({ "n", "v", "x" }, "<leader>tr", ":set invrelativenumber<CR>", opts)
-- (t)oggle (s)pell
m({ "n", "v", "x" }, "<leader>ts", ":set spell!<CR>", opts)
-- delete to void register
m({ "n", "v", "x" }, "<leader>d", '"_d')
-- copy to system clipboard
m({ "n", "v", "x" }, "<leader>y", '"+y')
m({ "n", "v", "x" }, "<leader>Y", '"+Y')
