return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		-- add options here
		-- or leave it empty to use the default settings
		default = {
			dir_path = function()
				return vim.fn.getcwd() .. "/1. RESOURCE/Pics"
			end,
			extension = "avif", ---@type string
			process_cmd = "convert - -quality 75 avif:-", ---@type string
		},
	},
	keys = {
		-- suggested keymap
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}
