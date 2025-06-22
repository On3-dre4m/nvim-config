return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavor = "mocha",
				-- transparent_background = true,
				integrations = {
					gitsigns = true,
					flash = true,
					blink_cmp = true,
				},
				highlight_overrides = {
					all = function(colors)
						return {
							LineNrAbove = { fg = "#808080" },
							CursorLineNr = { fg = "#17fff7" },
							LineNrBelow = { fg = "#808080" },
							ColorColumn = { bg = "#6F4B72" }, -- Highlight the color column
						}
					end,
				},
			})
			vim.cmd.colorscheme("catppuccin")

			-- Delay applying highlights slightly to ensure they take effect
			vim.keymap.set("n", "<leader>T", function()
				local cat = require("catppuccin")
				cat.options.transparent_background = not cat.options.transparent_background
				cat.compile()
				vim.cmd.colorscheme(vim.g.colors_name)
			end)
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = false,
				styles = {
					sidebars = "dark",
					floats = "dark",
				},

				on_highlights = function(hl, c)
					hl.LineNrAbove = { fg = "#808080" }
					hl.CursorLineNr = { fg = "#17fff7" }
					hl.LineNrBelow = { fg = "#808080" }
					hl.ColorColumn = { bg = "#6F4B72" } -- Highlight the color column
					hl.BlinkCmpMenuSelection = { bg = "#45475b" }
				end,
			})
		end,
	},

	{
		"xiyaowong/transparent.nvim",
		config = function()
			vim.keymap.set("n", "<leader>tt", function()
				vim.cmd("TransparentToggle")
			end, { silent = true, desc = "[T]oggle [T]ransparrent" })
		end,
	},
}
