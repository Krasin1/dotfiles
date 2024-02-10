local map = vim.api.nvim_set_keymap

-- Use alt + hjkl to resize windows
map('n', '<M-j>', ':resize -2<cr>', { silent = true, noremap = true })
map('n', '<M-k>', ':resize +2<cr>', { silent = true, noremap = true })
map('n', '<M-h>', ':vertical resize +2<cr>', { silent = true, noremap = true })
map('n', '<M-l>', ':vertical resize -2<cr>', { silent = true, noremap = true })

-- Easy CAPS
map('n', '<Leader>u', 'viwU<Esc>', { silent = true, noremap = true })

-- TAB in general mode will move to text buffer
map('n', '<TAB>n', ':bn<CR>', { silent = true, noremap = true })
map('n', '<TAB>p', ':bp<CR>', { silent = true, noremap = true })
map('n', '<TAB>q', ':bd!<CR>', { silent = true, noremap = true })

-- Alternate way to save
map('n', '<C-s>', ':w<CR>', { silent = true, noremap = true })
-- Use control-c instead of escape
map('n', '<C-c>', '<Esc>', { silent = true, noremap = true })

-- Better tabbing
map('v', '<', '<gv', { silent = true, noremap = true })
map('v', '>', '>gv', { silent = true, noremap = true })

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { silent = true, noremap = true })
map('n', '<C-j>', '<C-w>j', { silent = true, noremap = true })
map('n', '<C-k>', '<C-w>k', { silent = true, noremap = true })
map('n', '<C-l>', '<C-w>l', { silent = true, noremap = true })


-- Navbuddy
map('n', '<leader>n', ':Navbuddy<CR>', { silent = true, noremap = true })
