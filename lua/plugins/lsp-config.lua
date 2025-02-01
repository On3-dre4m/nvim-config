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
				ensure_installed = { "lua_ls", "clangd", "ruff" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
			--Set keymap for hover function
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", function()
				-- vim.cmd("vsplit")
				-- vim.cmd("wincmd l")
				vim.lsp.buf.definition()
			end, { silent = true, desc = "[G]oto [D]efinition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "show [C]ode [A]ction" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "show [G]oto [R]eference" })
			--vim.keymap.set()
		end,
	},
}
