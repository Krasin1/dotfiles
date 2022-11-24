vim.cmd [[highlight IndentBlanklineIndent1 guifg=#323232 gui=nocombine]]

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1"
    },
}
