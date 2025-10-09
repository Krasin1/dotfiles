-- disalbe commenting next line
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

return {
	"numToStr/Comment.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		toggler = {
			line = "<leader>c",
			block = "<leader>'",
		},
		opleader = {
			line = "<leader>c",
			block = "<leader>'",
		},
		mappings = {
			basic = true,
			extra = false,
		},
	},
}
