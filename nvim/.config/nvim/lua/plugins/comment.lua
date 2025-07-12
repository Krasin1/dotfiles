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
