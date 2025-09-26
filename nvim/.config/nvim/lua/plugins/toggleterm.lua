return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			direction = "float",
            start_in_insert = true,
			float_opts = {
				border = "double",
				winblend = 0,
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			local Terminal = require("toggleterm.terminal").Terminal

			-- создаём 4 фиксированных терминала
			local term1 = Terminal:new({ count = 1, display_name = " Terminal 1 ", hidden = true, direction = "float" })
			local term2 = Terminal:new({ count = 2, display_name = " Terminal 2 ", hidden = true, direction = "float" })
			local term3 = Terminal:new({ count = 3, display_name = " Terminal 3 ", hidden = true, direction = "float" })
			local term4 = Terminal:new({ count = 4, display_name = " Terminal 4 ", hidden = true, direction = "float" })

			-- F1–F4: переключение между отдельными терминалами
			vim.keymap.set({ "n", "t" }, "<F1>", function()
				term1:toggle()
			end, { desc = "Terminal 1" })
			vim.keymap.set({ "n", "t" }, "<F2>", function()
				term2:toggle()
			end, { desc = "Terminal 2" })
			vim.keymap.set({ "n", "t" }, "<F3>", function()
				term3:toggle()
			end, { desc = "Terminal 3" })
			vim.keymap.set({ "n", "t" }, "<F4>", function()
				term4:toggle()
			end, { desc = "Terminal 4" })

			-- Leader-tt = первый терминал
			vim.keymap.set("n", "<leader>tt", function()
				term1:toggle()
			end, { desc = "Terminal Toggle" })

			-- Leader-tp = Python-терминал (отдельный, как "floaterm new python")
			local python = Terminal:new({ cmd = "python", display_name = " Python ", hidden = true, direction = "float" })
			vim.keymap.set("n", "<leader>tp", function()
				python:toggle()
			end, { desc = "Terminal Python" })

			-- выход из python-терминала по ESC
			vim.keymap.set("t", "<Esc>", function()
				if python:is_open() then
					python:toggle() -- закроет окно
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
				end
			end, { desc = "Close Python terminal on ESC" })
		end,
	},
}
