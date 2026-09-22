return {
	{
		"milanglacier/minuet-ai.nvim",
		event = { "InsertEnter" },
		config = function()
			require("minuet").setup({
				provider = "openai_compatible",
				n_completions = 3,
				context_window = 2048,
				throttle = 400,
				debounce = 100,
				request_timeout = 0,
				notify = false,
				provider_options = {
					openai_compatible = {
						api_key = "TERM",
						name = "Llama.cpp",
						end_point = "http://127.0.0.1:8080/v1/chat/completions",
						model = "qwopus35b",
						optional = {
							max_tokens = 256,
							top_p = 0.9,
							chat_template_kwargs = {
								enable_thinking = false,
							},
						},
					},
				},
			})

			vim.keymap.set("i", "<A-y>", function()
				require("blink.cmp").show { providers = { "minuet" } }
			end, { desc = "Minuet completion" })
		end,
	},
}
