local g = vim.g

g.floaterm_keymap_toggle = '<F1>'
g.floaterm_keymap_next = '<F2>'
g.floaterm_keymap_prev = '<F3>'
g.floaterm_keymap_new = '<F4>'

g.floaterm_gitcommit = 'floaterm'
g.floaterm_autoinsert = 1
g.floaterm_width = 0.8
g.floaterm_height = 0.8
g.floaterm_wintitle = 0
g.floaterm_autoclose = 1

vim.api.nvim_set_keymap('n', '<Leader>tt', ":FloatermToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>tp', ":FloatermNew python<cr>", { silent = true, noremap = true })
