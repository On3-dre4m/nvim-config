return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Vault",
					path = "/mnt/E_Drive/Workplace/Obsidian/Vault",
				},
			},

			notes_subdir = "Fleeting Notes",
			new_notes_location = "notes_subdir",

			templates = {
				folder = "1. RESOURCE/Template",
			}, -- see below for full list of options 👇

			mapping = {
				-- Toggle check-boxes.
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},
			ui = { enable = false },
			disable_frontmatter = true,
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		opts = { file_types = { "markdown", "Avante" } },
		ft = { "markdown", "Avante" },
		config = function()
			require("render-markdown").setup({
				dash = {
					enabled = false,
				},
				heading = {
					width = "block",
					left_pad = 2,
					right_pad = 4,
				},
				code = {
					sign = false,
					width = "block",
					left_pad = 2,
					right_pad = 4,
				},
			})
		end,
	},
}
