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
map("n", "<leader>ha", h .. "mark').add_file()<cr>", { desc = "Add file to harpoon", silent = true, noremap = true })
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

-- Toggle between cp1251 and the original encoding
local original_encoding = nil
vim.keymap.set("n", "<leader>ee", function()
  local enc = vim.bo.fileencoding
  if enc == "cp1251" then
    if original_encoding then
      vim.cmd("e ++enc=" .. original_encoding)
      print("🔤 Encoding: " .. original_encoding)
    else
      vim.cmd("e ++enc=utf-8")
      print("🔤 Encoding: utf-8 (no previous encoding saved)")
    end
  else
    original_encoding = enc
    vim.cmd("e ++enc=cp1251")
    print("🔤 Encoding: cp1251 (saved " .. enc .. ")")
  end
end, { desc = "Toggle CP1251 and previous encoding" })

-- enter normal mode from terminal
map("t", "<C-Backspace>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { silent = true, noremap = true, desc = "Open Diagnostics in Float" })

map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", { silent = true, noremap = true, desc = "LSP: [R]e[n]ame" })
--
map(
	"n",
	"<leader>a",
	":lua require('fzf-lua').lsp_code_actions()<cr>",
	{ silent = true, noremap = true, desc = "LSP: Code [A]ction" }
)
map(
	"x",
	"<leader>a",
	":lua require('fzf-lua').lsp_code_actions()<cr>",
	{ silent = true, noremap = true, desc = "LSP: Code [A]ction" }
)
-- Find references for the word under your cursor.
map(
	"n",
	"gr",
	":lua require('fzf-lua').lsp_references()<cr>",
	{ silent = true, noremap = true, desc = "LSP: [G]oto [R]eferences" }
)
-- Jump to the implementation of the word under your cursor.
map(
	"n",
	"gi",
	":lua require('fzf-lua').lsp_implementations()<cr>",
	{ silent = true, noremap = true, desc = "LSP: [G]oto [I]mplementation" }
)
-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
map(
	"n",
	"gd",
	":lua require('fzf-lua').lsp_definitions()<cr>",
	{ silent = true, noremap = true, desc = "LSP: [G]oto [D]efinition" }
)
--
map(
	"n",
	"gD",
	":lua require('fzf-lua').lsp_declarations()<cr>",
	{ silent = true, noremap = true, desc = "LSP: [G]oto [D]eclaration" }
)
-- Fuzzy find all the symbols in your current document.
map(
	"n",
	"gO",
	":lua require('fzf-lua').lsp_document_symbols()<cr>",
	{ silent = true, noremap = true, desc = "LSP: Open Document Symbols" }
)
-- Fuzzy find all the symbols in your current workspace.
--  Similar to document symbols, except searches over your entire project.
map(
	"n",
	"gW",
	":lua require('fzf-lua').lsp_live_workspace_symbols()<cr>",
	{ silent = true, noremap = true, desc = "LSP: Open Workspace Symbols" }
)
-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
map(
	"n",
	"gtd",
	":lua require('fzf-lua').lsp_typedefs()<cr>",
	{ silent = true, noremap = true, desc = "LSP: [G]oto [T]ype [D]efinition" }
)

-- The following code creates a keymap to toggle inlay hints in your code
local function toggle_inlay_hints()
	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end

-- Маппинг
vim.keymap.set(
	"n",
	"<leader>th",
	toggle_inlay_hints,
	{ silent = true, noremap = true, desc = "[T]oggle inlay [H]ints" }
)
-- map("n", "<leader>th", ":lua function() local bufnr = vim.api.nvim_get_current_buf() local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) vim.lsp.inlay_hint.enable(not enabled, bufnr) end <cr>", { silent = true, noremap = true, desc = "LSP: [T]oggle Inlay [H]ints"})
-- map("n", "<leader>th", ":lua (function() local bufnr = vim.api.nvim_get_current_buf() local enabled = vim.lsp.inlay_hint.is_enabled(bufnr) vim.lsp.inlay_hint.enable(not enabled, bufnr) end)()<cr>", { silent = true, noremap = true, desc = "LSP: [T]oggle Inlay [H]ints"})
