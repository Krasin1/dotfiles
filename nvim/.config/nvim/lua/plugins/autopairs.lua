return {
    {
		"echasnovski/mini.pairs",
		event = { "InsertEnter", "CmdlineEnter" },
		version = false,
		opts = {
			modes = {
				insert = true,
				command = true,
				terminal = false,
			},
		},
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
