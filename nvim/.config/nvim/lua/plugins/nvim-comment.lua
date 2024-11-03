return {
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup({
                comment_empty = false,
				line_mapping = "<leader>'",
				operator_mapping = "<leader>c",
			})
			-- vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
			vim.cmd([[
            " when you enter a (new) buffer
            augroup set-commentstring-ag
            autocmd!
            autocmd BufEnter *.cpp,*.hpp,*.c,*.h*,.glsl :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
            " when you've changed the name of a file opened in a buffer, the file type may have changed
            autocmd BufFilePost *.cpp,*.hpp,*.c,*h,*.glsl :lua vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
            augroup END
            ]])
		end,
	},
}
