vim.g.mapleader = " "

local t = vim.opt

t.clipboard = "unnamedplus"
t.termguicolors = true
t.signcolumn = "yes"
t.hlsearch = false
t.errorbells = false
t.incsearch = true
t.hidden = true
t.wrap = true
t.encoding = "utf-8"
t.pumheight = 10
t.fileencoding = "utf-8"
t.ruler = true
t.cmdheight = 2
t.iskeyword:append({ "-" })
t.mouse = "a"
t.splitbelow = true
t.splitright = true
t.conceallevel = 0
t.tabstop = 4
t.softtabstop = 4
t.scrolloff = 8
t.shiftwidth = 4
t.smarttab = true
t.expandtab = true
t.smartindent = true
t.autoindent = true
t.laststatus = 0
t.number = true
t.relativenumber = true
t.cursorline = true
t.updatetime = 50
t.timeoutlen = 500
t.formatoptions:remove({ "c", "r", "o" })
t.shortmess:append({ c = true })
t.ignorecase = true
t.smartcase = true
