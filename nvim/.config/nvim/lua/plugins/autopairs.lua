return {
	-- {
	--     "m4xshen/autoclose.nvim",
	--     config = function()
	--         require("autoclose").setup({
	--             keys = {
	--                 ["<"] = { escape = false, close = true, pair = "<>" }
	--             },
	--             options = {
	--                 pair_spaces = true
	--             }
	--         })
	--     end
	-- },
	{
		"saghen/blink.pairs",
		version = "*", -- (recommended) only required with prebuilt binaries
		dependencies = "saghen/blink.download",

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable()
				-- and require("blink.pairs.mappings").disable()
				-- to enable/disable mappings at runtime
				enabled = true,
				-- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
				-- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
				pairs = { ['<'] = '>' },
			},
			highlights = {
				enabled = true,
				-- requires require('vim._extui').enable({}), otherwise has no effect
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
				},

				-- highlights matching pairs under the cursor
				matchparen = {
					enabled = true,
					-- known issue where typing won't update matchparen highlight, disabled by default
					group = "BlinkPairsMatchParen",
				},
			},
			debug = false,
		},
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
