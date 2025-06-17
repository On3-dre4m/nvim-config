return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		-- event = "BufReadPost",
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

			openai = {
				endpoint = "http://localhost:1234/v1",
				model = "qwen/qwen3-8b", -- your desired model (or use gpt-4o, etc.)
				extra_request_body = {
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					temperature = 0.4, -- Adjust this value as needed
					max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
				},
				-- disable_tools = { "web_search", "fetch", "git_commit" }, -- Disable unsupported tools
				disable_tools = true, -- Disable unsupported tools
				api_key_name = "",
				--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models,
			},
			provider = "openai",
			providers = {
				math = {
					__inherited_from = "openai",
					endpoint = "http://localhost:1234/v1",
					model = "mistralai/mathstral-7b-v0.1",
					extra_request_body = {
						timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
					},
					disable_tools = true, -- Disable unsupported tools
					api_key_name = "",
				},

				metallm = {
					__inherited_from = "openai",
					endpoint = "http://localhost:1234/v1",
					model = "meta-llama-3.1-8b-instruct",
					extra_request_body = {
						timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
					},
					-- disable_tools = { "web_search", "fetch", "git_commit" }, -- Disable unsupported tools
					disable_tools = true, -- Disable unsupported tools

					api_key_name = "",
				},

				deepseek = {
					__inherited_from = "openai",
					endpoint = "http://localhost:1234/v1",
					model = "deepseek/deepseek-r1-0528-qwen3-8b",
					extra_request_body = {
						timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
					},
					disable_tools = true, -- Disable unsupported tools
					api_key_name = "",
				},

				gemma = {
					__inherited_from = "openai",
					endpoint = "http://localhost:1234/v1",
					model = "google/gemma-3-4b",
					extra_request_body = {
						timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
					},
					disable_tools = true, -- disable tools!
					api_key_name = "",
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
