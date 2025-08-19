return {
	"mikavilpas/yazi.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			"<leader>y",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
	},

	opts = {
		open_for_directories = true,
		keymaps = { show_help = "<f1>" },
		floating_window_scaling_factor = 0.7,
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1

		-- HACK: открываем и закрываем невидимый терминал,
		-- чтобы yazi при старте не съезжал внутри окна.
		-- Оно само проходит после 5-10 секунд после запуска,
		-- но это слишком медленнно. Почему это работает хз.

		local buf = vim.api.nvim_create_buf(false, true)
		local win = vim.api.nvim_open_win(buf, false, {
			relative = "editor",
			width = 1,
			height = 1,
			row = 0,
			col = 0,
			style = "minimal",
			border = "none",
		})
		local chan = vim.api.nvim_open_term(buf, {})
		vim.api.nvim_chan_send(chan, ";\n")
		vim.defer_fn(function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end, 0)
	end,
}
