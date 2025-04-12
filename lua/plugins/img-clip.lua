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
				relative = "cursor",
				border = "rounded",
				focusable = false,
				backdrop = false,
				row = 1,
				col = 1,
				-- width/height are automatically set by the image size unless specified below
			},
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = true,
					max_width = 80,
					max_height = 40,
				},
			},
		},
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	config = function()
	-- 		require("image").setup({
	-- 			backend = "kitty",
	-- 			integrations = {
	-- 				markdown = {
	-- 					enabled = true,
	-- 					clear_in_insert_mode = false,
	-- 					only_render_image_at_cursor = true,
	-- 					filetypes = { "markdown", "vimwiki" },
	-- 					resolve_image_path = function(document_path, image_path, fallback)
	-- 						-- document_path is the path to the file that contains the image
	-- 						-- image_path is the potentially relative path to the image. for
	-- 						-- markdown it's `![](this text)`
	-- 						local image_dir = "/mnt/E_Drive/Workplace/Obsidian/Vault/1. RESOURCE/Pics"
	-- 						-- you can call the fallback function to get the default behavior
	-- 						-- Check if the image_path is already an absolute path
	-- 						if image_path:match("^/") then
	-- 							-- If it's an absolute path, leave it unchanged
	-- 							return image_path
	-- 						elseif image_path:match("^%.%.") then
	-- 							-- return vim.fn.expand("%:p:h") .. image_path
	-- 							return fallback(document_path, image_path)
	-- 						end
	--
	-- 						-- Construct the new image path by prepending the Assets directory
	-- 						local new_image_path = image_dir .. "/" .. image_path
	--
	-- 						-- Check if the constructed path exists
	-- 						return new_image_path
	-- 					end,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
