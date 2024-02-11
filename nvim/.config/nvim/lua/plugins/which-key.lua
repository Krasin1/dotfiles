return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
		config = function()
			local wk = require("which-key")

			wk.register({
				["<leader>"] = {
					f = {
						name = "file", -- optional group name
						r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false }, -- additional options for creating the keymap
					},
					d = {
						name = "Debugging",
					},
					t = {
						name = "Open Terminal",
					},
					c = "Comment block",
					l = "Comment line",
				},
				["\\ca"] = "Code action",
				["\\rn"] = "Rename",
				["\\pd"] = "Peek definition",
				["\\gh"] = "Lspsaga finder",
				["\\"] = {
					l = "Line diagnostics",
					D = "Type definition",
					c = { name = "Code action" },
					r = { name = "Rename" },
					p = { name = "Peek definition" },
					g = { name = "Lspsaga finder" },
				},
			})
		end,
	},
}
