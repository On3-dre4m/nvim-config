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
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup({
				extensions = {
					avante = {
						make_slash_commands = true, -- make /slash commands from MCP server prompts
					},
				},
			})
		end,
	},

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			-- add any opts here

			-- system_prompt as function ensures LLM always has latest MCP server state
			-- This is evaluated for every message, even in existing chats
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			-- Using function prevents requiring mcphub before it's loaded
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,

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

			provider = "deepSeekV3",

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
					model = "llama-3.3-70b-versatile",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
						-- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
					},
					-- disable_tools = true,
				},

				--MISTRAL LLMs can use tools support MCP
				mistral = {
					__inherited_from = "openai",
					api_key_name = "MISTRAL_API_KEY",
					endpoint = "https://api.mistral.ai/v1/",
					model = "codestral-2501",
					extra_request_body = {
						max_tokens = 6000, -- to avoid using max_completion_tokens
					},
					-- disable_tools = true,
				},

				--Deep Seek chat V3 can use MCP and native Avante tools
				deepSeekV3 = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					-- model = "qwen/qwen-2.5-coder-32b-instruct:free",
					model = "deepseek/deepseek-chat-v3-0324:free",
					timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
					extra_request_body = {
						temperature = 0.4, -- Adjust this value as needed
						max_completion_tokens = 6000, -- Increase this to include reasoning tokens (for reasoning models)
						-- reasoning_effort = "low", -- low|medium|high, only used for reasoning models
					},
					-- disable_tools = true, -- Disable unsupported tools
				},

				--DeepSeek R1 can not use MCP or Avante native tools
				deepSeekR1 = {
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
