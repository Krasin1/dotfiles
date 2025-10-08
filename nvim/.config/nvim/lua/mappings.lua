local map = vim.api.nvim_set_keymap

-- Paste without overwriting the register
map("v", "p", '"_dP', { silent = true, noremap = true })

-- Keep cursor in place when joining lines
map("n", "J", "mzJ`z", { silent = true, noremap = true })

-- Center search results
map("n", "n", "nzzzv", { silent = true, noremap = true })
map("n", "N", "Nzzzv", { silent = true, noremap = true })

-- Use alt + hjkl to resize windows
map("n", "<M-j>", ":resize -2<cr>", { desc = "Decrease window height", silent = true, noremap = true })
map("n", "<M-k>", ":resize +2<cr>", { desc = "Increase window height", silent = true, noremap = true })
map("n", "<M-h>", ":vertical resize +2<cr>", { desc = "Increase window width", silent = true, noremap = true })
map("n", "<M-l>", ":vertical resize -2<cr>", { desc = "Decrease window width", silent = true, noremap = true })

-- TAB in general mode will move to text buffer
map("n", "<TAB>n", ":bn<CR>", { desc = "Next buffer", silent = true, noremap = true })
map("n", "<TAB>p", ":bp<CR>", { desc = "Previous buffer", silent = true, noremap = true })
map("n", "<TAB>q", ":bd!<CR>", { desc = "Close buffer", silent = true, noremap = true })

-- Alternate way to save
map("n", "<C-s>", ":w<CR>", { desc = "Save file", silent = true, noremap = true })

-- Better escape
map("n", "<C-c>", "<Esc>", { silent = true, noremap = true })
map("i", "jk", "<Esc>", { silent = true, noremap = true })

-- Better tabbing
map("v", "<", "<gv", { silent = true, noremap = true })
map("v", ">", ">gv", { silent = true, noremap = true })

-- Move selected line / block of text
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, noremap = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, noremap = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { silent = true, noremap = true })
map("n", "<C-j>", "<C-w>j", { silent = true, noremap = true })
map("n", "<C-k>", "<C-w>k", { silent = true, noremap = true })
map("n", "<C-l>", "<C-w>l", { silent = true, noremap = true })

-- Harpoon
local h = ":lua require('harpoon."
map("n", "<leader>a", h .. "mark').add_file()<cr>", { desc = "Add file to harpoon", silent = true, noremap = true })
map(
	"n",
	"<leader>d",
	h .. "ui').toggle_quick_menu()<cr>",
	{ desc = "Open harpoon mark", silent = true, noremap = true }
)

map("n", "<leader>hn", h .. "ui').nav_next()<cr>", { desc = "Next harpoon file", silent = true, noremap = true })
map("n", "<leader>hp", h .. "ui').nav_prev()<cr>", { desc = "Prev harpoon file", silent = true, noremap = true })

map("n", "<leader>j", h .. "ui').nav_file(1)<cr>", { desc = "Harpoon 1", silent = true, noremap = true })
map("n", "<leader>k", h .. "ui').nav_file(2)<cr>", { desc = "Harpoon 2", silent = true, noremap = true })
map("n", "<leader>l", h .. "ui').nav_file(3)<cr>", { desc = "Harpoon 3", silent = true, noremap = true })
map("n", "<leader>;", h .. "ui').nav_file(4)<cr>", { desc = "Harpoon 4", silent = true, noremap = true })

-- debug
map("n", "<leader>bt", "<cmd>DapToggleBreakpoint<cr>", {})
map("n", "<leader>bc", "<cmd>DapContinue<cr>", {})

-- enter normal mode from terminal
map("t", "<C-Backspace>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostics in Float", silent = true, noremap = true })
