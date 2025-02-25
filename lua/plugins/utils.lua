return {
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		opts = {
			focus = true,
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Open trouble document diagnostics",
			},
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		},
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"moll/vim-bbye",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- vim.opt.linespace = 8
			require("bufferline").setup({
				options = {
					mode = "buffers", -- set to "tabs" to only show tabpages instead
					themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
					numbers = "ordinal", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
					close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
					right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
					left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
					middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
					-- buffer_close_icon = '󰅖',
					buffer_close_icon = "✗",
					-- buffer_close_icon = '✕',
					close_icon = "",
					path_components = 1, -- Show only the file name without the directory
					modified_icon = "●",
					left_trunc_marker = "",
					right_trunc_marker = "",
					max_name_length = 30,
					max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
					tab_size = 21,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict)
						local s = " "
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and " " or (e == "warning" and " " or " ")
							s = s .. n .. sym
						end
						return s
					end,
					diagnostics_update_in_insert = false,
					color_icons = true,
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = true,
					persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
					separator_style = { "|", "|" }, -- | "thick" | "thin" | { 'any', 'any' },
					enforce_regular_tabs = true,
					always_show_bufferline = true,
					show_tab_indicators = false,
					indicator = {
						-- icon = '▎', -- this should be omitted if indicator style is not 'icon'
						style = "none", -- Options: 'icon', 'underline', 'none'
					},
					icon_pinned = "󰐃",
					minimum_padding = 1,
					maximum_padding = 5,
					maximum_length = 15,
					sort_by = "insert_at_end",
				},
				highlights = {
					separator = {
						fg = "#A9A9A9",
					},
					buffer_selected = {
						bold = true,
						italic = false,

						fg = "#33ffff",
					},
					-- separator_selected = {},
					-- tab_selected = {},
					-- background = {},
					-- indicator_selected = {
					-- },
					-- fill = {},
				},
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>ll", ":BufferLinePick<CR>", { silent = true, desc = "[P]ick Buffer Line" })
			vim.keymap.set(
				"n",
				"<leader>lc",
				":BufferLinePickClose<CR>",
				{ silent = true, desc = "[P]ick [C]lose Buffer Line" }
			)
			vim.keymap.set(
				"n",
				"<leader>co",
				":BufferLineCloseOthers<CR>",
				{ silent = true, desc = "[C]lose others Buffer Line" }
			)
			vim.keymap.set(
				"n",
				"<leader>cc",
				":BufferLinePickClose<CR>",
				{ silent = true, desc = "[C]lose [C]urrent Buffer Line" }
			)
			vim.keymap.set(
				"n",
				"<leader>lm",
				":BufferLineCycleNext<CR>",
				{ silent = true, desc = "Buffer [L]ine Cycle [N]ext" }
			)
			vim.keymap.set(
				"n",
				"<leader>ln",
				":BufferLineCyclePrev<CR>",
				{ silent = true, desc = "Buffer [L]ine Cycle [P]revious" }
			)
		end,
	},
}
