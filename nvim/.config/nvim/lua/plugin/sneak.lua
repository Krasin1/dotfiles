local g = vim.g

g['sneak#label'] = 1
g['sneak#s_next'] = 1

vim.api.nvim_command([[
    map t <Plug>Sneak_;
    map T <Plug>Sneak_,
]])
