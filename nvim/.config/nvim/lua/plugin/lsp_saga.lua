local lspsaga = require 'lspsaga'

lspsaga.init_lsp_saga{ -- defaults ...
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code action title icon
  code_action_icon = " ",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "single",
  rename_prompt_prefix = "➤",
  server_filetype_map = {},
}

--- In lsp attach function
local map = vim.api.nvim_set_keymap
map("n", "\\rn", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
map("n", "\\ca", "<cmd>Lspsaga code_action<cr>", {silent = true, noremap = true})
map("x", "\\ca", "<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true})
map("n", "\\gh", "<cmd>lua require('lspsaga.provider').lsp_finder()<cr>", {silent = true, noremap = true})
map("n", "\\pd", "<cmd>lua require('lspsaga.provider').preview_definition()<cr>", {silent = true, noremap = true})
map("n", "K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
map("n", "\\l", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", {silent = true, noremap = true})
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", {silent = true, noremap = true})
map("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>", {silent = true, noremap = true})
map("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>", {silent = true, noremap = true})
