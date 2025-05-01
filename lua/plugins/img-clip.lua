return {
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			default = {
				use_absolute_path = false, ---@type boolean

				dir_path = function()
					return vim.fn.getcwd() .. "/1. RESOURCE/Pics"
				end,
				extension = "avif", ---@type string
				process_cmd = "convert - -quality 75 avif:-", ---@type string
				prompt_for_file_name = true,
			},
		},
		keys = {
			-- suggested keymap
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},

	{
		"folke/snacks.nvim",
		opts = {
			styles = {
				snacks_image = {
					relative = "editor", -- position relative to the whole editor
					border = "rounded",
					focusable = false,
					backdrop = false,
					row = 1, -- distance from top
					col = vim.o.columns, -- dynamically push to the right (40 cols from right edge)
					zindex = 100, -- ensure it's on top
					-- optionally fix width/height if you want uniform sizing
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
				},
			},
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = true,
					max_width = 80,
					max_height = 60,
					conceal = function(lang, type)
						-- only conceal math expressions
						return not type == "math"
					end,
				},
				convert = {
					notify = false,
				},
				---@class snacks.image.convert.Config
				math = {
					enabled = true,
				},
			},
		},
	},
}
