return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Language Server Protocol
					"lua-language-server",
					"clangd",
					"pyright",
					"harper-ls",
					"texlab",
					"markdown-oxide",
					"ltex-ls-plus",

					-- Debug Adapter Protocol
					"cortex-debug",
					"cpptools",
					"debugpy",

					-- Linter
					"cpplint",
					"markdownlint-cli2",
					"mypy",
					"pylint",

					-- Formatter
					"black",
					"clang-format",
					"isort",
					"latexindent",
					"markdown-toc",
					"markdownlint-cli2",
					"prettier",
					"prettierd",
					"stylua",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "ruff", "pylsp", "harper_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"barreiroleo/ltex_extra.nvim",
			"saghen/blink.cmp",
		},

		config = function()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")
			-- vim.diagnostic.config({
			-- 	update_in_insert = false,
			-- })

			-- local util = require("lspconfig.util")
			local border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			}

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = border,
				padding = { 2, 2 },
			})
			--Where to add LSP for Language
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							-- Tell Lua language server to use Lua 5.1 (LuaJIT) which is used by Neovim
							version = "LuaJIT",
							-- Setup Neovim runtime files for completion
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							-- Recognize `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							-- Stop prompting about 'luassert' or third-party libraries
							checkThirdParty = false,
						},
						telemetry = {
							-- Disable telemetry data collection
							enable = false,
						},
					},
				},
			}, { capabilities = capabilities })

			lspconfig.clangd.setup({

				cmd = {
					"clangd",
				},

				capabilities = capabilities,
			})
			lspconfig.csharp_ls.setup({ capabilities = capabilities })

			lspconfig.pylsp.setup({
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								ignore = { "W391", "E265" },
								maxLineLength = 100,
							},
						},
					},
				},
				capabilities = capabilities,
			})

      lspconfig.harper_ls.setup({
				filetypes = { "markdown" },
				settings = {
					["harper-ls"] = {
						userDictPath = "",
						fileDictPath = "",
						linters = {
							SpellCheck = true,
							SentenceCapitalization = true,
						},
						codeActions = {
							ForceStable = false,
						},
						markdown = {
							IgnoreLinkTitle = true,
						},
						diagnosticSeverity = "hint",
						isolateEnglish = false,
					},
				},
			})

			-- lspconfig.ltex_plus.setup({
			-- 	capabilities = capabilities,
			-- 	cmd = { "ltex-ls-plus" },
			-- 	settings = {
			-- 		ltex = {
			-- 			enabled = { "bib", "context", "plaintex", "tex", "latex" },
			-- 			language = "en-US",
			-- 			disabledRules = {
			-- 				-- "UPPERCASE_SENTENCE_START", -- Disable specific rules if needed
			-- 				["en-US"] = {
			-- 					"MORFOLOGIK_RULE_EN_US",
			-- 					"LC_AFTER_PERIOD",
			-- 					"EN_MULTITOKEN_SPELLING_TWO",
			-- 					"ENGLISH_WORD_REPEAT_BEGINNING_RULE",
			-- 					"COMMA_PARENTHESIS_WHITESPACE",
			-- 					"INTERJECTIONS_PUNCTUATION",
			-- 				},
			-- 			},
			-- 			hiddenFalsePositives = true,
			-- 		},
			-- 	},
			-- })

			lspconfig.texlab.setup({
				capabilities = capabilities,
			})

			lspconfig.markdown_oxide.setup({
				capabilities = capabilities,
			})

			--Set keymap for hover function
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { silent = true, desc = "[G]oto [D]efinition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "show [C]ode [A]ction" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "show [G]oto [R]eference" })
			--vim.keymap.set()
		end,
	},
}
