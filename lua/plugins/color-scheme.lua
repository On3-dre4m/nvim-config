return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavor = "mocha",
				transparent_background = true,
				integrations = {
					gitsigns = true,
					flash = true,
					blink_cmp = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
			-- Delay applying highlights slightly to ensure they take effect
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
				vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
				vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
			end, 50) -- Delay by 50ms

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
			})

			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
				vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
				vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
			end, 50) -- Delay by 50ms
		end,
	},

	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
	},

	{
		"xiyaowong/transparent.nvim",
	},
}
