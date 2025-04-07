-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				-- See `:help gitsigns.txt`
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				signs_staged = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})

			---@keymaps
			vim.keymap.set(
				"n",
				"<leader>gp",
				":Gitsigns preview_hunk<CR>",
				{ silent = true, desc = "[G]it [P]review changes" }
			)
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = {
				char = "┆",
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "dracula",
				},
				sections = {
					lualine_x = {
						function()
							local ok, pomo = pcall(require, "pomo")
							if not ok then
								return ""
							end

							local timer = pomo.get_first_to_finish()
							if timer == nil then
								return ""
							end

							return "󰄉 " .. tostring(timer)
						end,
						"encoding",
						"fileformat",
						"filetype",
					},
				},
			})
		end,
	},
}
