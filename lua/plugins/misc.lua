return {
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- Hints keybinds
		"folke/which-key.nvim",
	},
	{
		"stevearc/resession.nvim",
		opts = {},
		config = function()
			local resession = require("resession")
			resession.setup({})

			-- Resession does NOTHING automagically, so we have to set up some keymaps
			vim.keymap.set("n", "<leader>ss", resession.save)
			vim.keymap.set("n", "<leader>sl", resession.load)
			vim.keymap.set("n", "<leader>sd", resession.delete)
		end,
	},
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify", -- Optional
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				-- TODO: Customize the notifications
				message = {
					-- Messages shown by lsp servers
					enabled = true,
					view = "notify",
					opts = {},
				},
			}) -- Enable LSP message handling
			require("notify").setup({
				stages = "fade_in_slide_out", -- Animation style
				timeout = 8000, -- Time in milliseconds before notification disappears
				render = "default", -- Minimal UI for notifications
				fps = 60, -- Smooth animations
				background_colour = "#1e222a", -- Match your theme
				replace = true, -- Replace existing messages
			})
		end,
	},
}
