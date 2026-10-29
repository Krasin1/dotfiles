return {
	{
		"milanglacier/minuet-ai.nvim",
		event = { "InsertEnter" },
		config = function()
			require("minuet").setup({
				-- Qwen2.5-Coder supports native FIM tokens. Using FIM instead of
				-- /chat/completions avoids answers like "```cpp" and empty lines.
				provider = "openai_fim_compatible",
				-- Three separate requests. Run llama-server with
				-- `--parallel 3`, otherwise they queue on the only slot.
				n_completions = 1,
				context_window = 50000,
				-- Qwen sometimes repeats the code after the cursor. With this
				-- enabled Minuet trims the duplicated prefix/suffix.
				before_cursor_filter_length = 10,
				after_cursor_filter_length = 10,
				throttle = 500,
				debounce = 200,
				request_timeout = 6,
				notify = false,
				provider_options = {
					openai_fim_compatible = {
						-- llama.cpp needs no key; a constant function keeps
						-- the source available even when TERM is not set.
						api_key = function()
							return "no-key"
						end,
						name = "Llama.cpp",
						end_point = "http://127.0.0.1:8080/v1/completions",
						-- Must match the model name reported by llama.cpp.
						model = "coder3b",
						-- Keep streaming off: with llama.cpp Minuet sometimes
						-- fails to parse the SSE stream and returns nothing.
						stream = true,
						-- llama.cpp does not use the `suffix` field for FIM, so
						-- insert Qwen's special tokens manually.
						template = {
							prompt = function(context_before_cursor, context_after_cursor)
								return "<|fim_prefix|>"
									.. context_before_cursor
									.. "<|fim_suffix|>"
									.. context_after_cursor
									.. "<|fim_middle|>"
							end,
							suffix = false,
						},
						optional = {
							-- Short completions answer much faster and are less
							-- likely to be killed by request_timeout.
							max_tokens = 256,
							-- Low temperature makes all 3 requests identical;
							-- blink then deduplicates them into one item.
							temperature = 0.6,
							top_p = 0.9,
							top_k = 40,
							repeat_penalty = 1.20,
							-- Do not stop on "\n\n": a completion may start
							-- with a newline and become empty.
							stop = {
								"<|fim_pad|>",
								"<|endoftext|>",
								"<|file_separator|>",
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
