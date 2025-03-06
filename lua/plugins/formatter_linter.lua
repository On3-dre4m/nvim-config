return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					c = { "clang_format" },
					cpp = { "clang_format" },
					python = { "isort", "black" },
					markdown = { "prettier" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				},
			})

			vim.keymap.set("n", "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "[F]ormat the code" })
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				c = { "cpplint" },
				cpp = { "cpplint" },
				python = { "ruff" },
				-- markdown = { "vale" },
			}
			require("lint.linters.ruff").cmd = vim.fn.stdpath("data") .. "/mason/bin/ruff"

			require("lint").linters.cpplint.args = {
				"--filter=-build/header_guard,-build/include_order,-build/include_subdir,-build/include_what_you_use,-legal/copyright,-whitespace/blank_line,-whitespace/parens,-whitespace/comma,-whitespace/semicolon,-whitespace/line_length,-whitespace/braces, -whitespace/indent, -whitespace/operators,-whitespace/comments,-readibility/alt_tokens",
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>L", function()
				lint.try_lint()
			end, { desc = "Trigger [L]inter for current file" })
		end,
	},
}
