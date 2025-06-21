return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = false,
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			-- add any opts here
			-- for example
			input = {
				provider = "snacks",
				provider_opts = {
					title = "Avante Input",
					icon = "",
				},
			},

			-- selector = {
			-- 	provider = "telescope",
			-- 	provider_opts = {},
			-- },

			mode = "legacy",

			-- openai = {
			-- 	endpoint = "http://localhost:1234/v1",
			-- 	model = "qwen/qwen3-8b", -- your desired model (or use gpt-4o, etc.)
			-- 	timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
			-- 	extra_request_body = {
			-- 		temperature = 0.4, -- Adjust this value as needed
			-- 		max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
			-- 		reasoning_effort = "low", -- low|medium|high, only used for reasoning models,
			-- 	},
			-- 	disable_tools = { "fetch", "git_commit" }, -- Disable unsupported tools
			-- 	-- disable_tools = true, -- Disable unsupported tools
			-- 	api_key_name = "",
			-- },

			provider = "gemini",

			providers = {

				gemini = {
					model = "gemini-2.0-flash",
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						generationConfig = {
							temperature = 0.45,
						},
					},
				},

				metallm = {
					__inherited_from = "openai",
					endpoint = "http://localhost:1234/v1",
					model = "meta-llama-3.1-8b-instruct",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
					},
					-- disable_tools = { "web_search", "fetch", "git_commit" }, -- Disable unsupported tools
					disable_tools = true, -- Disable unsupported tools

					api_key_name = "",
				},

				groq = {
					__inherited_from = "openai",
					api_key_name = "GROQ_API_KEY",
					endpoint = "https://api.groq.com/openai/v1/",
					model = "gemma2-9b-it",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 4096, -- Increase this to include reasoning tokens (for reasoning models)
						-- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
					},
					disable_tools = true,
				},

				mistral = {
					__inherited_from = "openai",
					api_key_name = "MISTRAL_API_KEY",
					endpoint = "https://api.mistral.ai/v1/",
					model = "mistral-small-2503",
					extra_request_body = {
						max_tokens = 4096, -- to avoid using max_completion_tokens
					},
					disable_tools = true,
				},

				openrouter = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					-- model = "qwen/qwen-2.5-coder-32b-instruct:free",
					model = "mistralai/devstral-small:free",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
						-- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
					},
					disable_tools = true, -- Disable unsupported tools
				},

				deepSeek = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					-- model = "qwen/qwen-2.5-coder-32b-instruct:free",
					model = "deepseek/deepseek-r1:free",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
						-- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
					},
					disable_tools = true, -- Disable unsupported tools
				},
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
}
