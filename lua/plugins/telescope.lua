return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim", "scottmckendry/telescope-resession.nvim", "sharkdp/fd" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [T]ags" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffer" })
			vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "[F]ind [C]olorscheme" })
			vim.keymap.set("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { desc = "[F]ind [S]ymbols" })
			vim.keymap.set("n", "<leader>fn", ":Noice telescope<CR>", { desc = "[F]ind [N]oice history" })

			-- require("myplugins.multigrep").setup()

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 30,
					previewer = true,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			require("telescope").setup({
				extensions = {
					resession = {
						prompt_title = "Find Sessions", -- telescope prompt title
						dir = "session", -- directory where resession stores sessions
					},
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
