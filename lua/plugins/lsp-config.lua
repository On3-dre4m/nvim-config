return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "ruff", "ltex", "pylsp" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- "hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")
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

			lspconfig.ltex.setup({
				on_attach = function(client, bufnr)
					-- Check if the current file is a markdown file
					local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

					-- If the filetype is 'markdown', disable LTeX features (optional)
					if ft == "markdown" then
						client.stop() -- Stop the LTeX server for markdown files
					end
				end,
				settings = {
					ltex = {
						language = "en-US",
						lint = {
							enabled = true, -- Disable all linting
							disable = { "MD_BE_NON_VBP", "MORFOLOGIK_RULE_EN_US" },
						},
					},
				},
				capabilities = capabilities,
			})

			lspconfig.texlab.setup({
				capabilities = capabilities,
			})

			--Set keymap for hover function
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { silent = true, desc = "[G]oto [D]efinition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "show [C]ode [A]ction" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "show [G]oto [R]eference" })
			--vim.keymap.set()
		end,
	},
}
