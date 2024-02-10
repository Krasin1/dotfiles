return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
            "nvim-telescope/telescope.nvim",
		},
        config = function()
            require("noice").setup({})
            vim.keymap.set("n", "<leader><bs>", "<cmd>NoiceDismiss<cr>", { desc = "Dissmiss Noice Message" })
        end
	},
}
