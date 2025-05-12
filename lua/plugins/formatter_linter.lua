return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			---Custom function
			local function find_clang_format_file()
				local cwd = vim.fn.getcwd()
				local file = cwd .. "/.clang-format"

				if vim.fn.filereadable(file) == 1 then
					return true
				else
					return false
				end
			end
			---

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
						args = function()
							if find_clang_format_file() then
								vim.notify("Using .clang-format file", vim.log.levels.INFO)
								return { "-style=file" }
							else
								vim.notify("Using the default format", vim.log.levels.INFO)
								return {
									"--style={BreakBeforeBinaryOperators: None, BreakBeforeBraces: Attach, AllowShortFunctionsOnASingleLine: None, ColumnLimit: 0, IndentWidth: 4, PenaltyBreakAssignment: 100, PenaltyBreakString: 100}",
								}
							end
						end,
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
				-- tex = { "vale" },
				-- markdown = { "vale" },
			}
			-- require("lint.linters.ruff").cmd = vim.fn.stdpath("data") .. "/mason/bin/ruff"
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
