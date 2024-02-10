return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					c = { "clang_format" },
					cpp = { "clang_format" },
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					rust = { "rustfmt" },
				},
				-- format_on_save = {
				-- 	-- These options will be passed to conform.format()
				-- 	timeout_ms = 500,
				-- 	lsp_fallback = true,
				-- },
			})
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	pattern = "*",
			-- 	callback = function(args)
			-- 		require("conform").format({ bufnr = args.buf })
			-- 	end,
			-- })

			vim.keymap.set({ "n", "v" }, "\\f", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range" })
		end,
	},
}
