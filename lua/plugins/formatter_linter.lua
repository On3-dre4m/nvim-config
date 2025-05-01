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
					tex = { "latexindent" },
					json = { "prettier" },
				},
				formatters = {
					clang_format = {
						prepend_args = {
							"--style={BreakBeforeBinaryOperators: None, BreakBeforeBraces: Attach, AllowShortFunctionsOnASingleLine: None, ColumnLimit: 0, IndentWidth: 4, PenaltyBreakAssignment: 100, PenaltyBreakString: 100}",
						},
					},
					latexindent = {
						prepend_args = {},
					},
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
				tex = { "vale" },
				-- markdown = { "vale" },
			}
			require("lint.linters.ruff").cmd = vim.fn.stdpath("data") .. "/mason/bin/ruff"
			-- require("lint.linters.vale").cmd = vim.fn.stdpath("data") .. "/mason/bin/vale"

			require("lint").linters.cpplint.args = {
				"--filter=-build/header_guard,-build/include,-build/include_order,-build/include_subdir,-build/include_what_you_use,-legal/copyright,-whitespace/blank_line,-whitespace/parens,-whitespace/comma,-whitespace/semicolon,-whitespace/line_length,-whitespace/braces,-whitespace/indent,-whitespace/operators,-whitespace/comments,-whitespace/tab,-readibility/alt_tokens,-readability/multiline_comment",
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
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
