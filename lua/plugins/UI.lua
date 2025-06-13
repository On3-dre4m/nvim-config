-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
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
					lualine_c = {
						{
							"filename",
							file_status = true, -- Displays file status (readonly status, modified status)
							newfile_status = false, -- Display new file status (new file means no write after created)
							path = 3, -- 0: Just the filename
							-- -- 1: Relative path
							-- -- 2: Absolute path
							-- -- 3: Absolute path, with tilde as the home directory
							-- -- 4: Filename and parent dir, with tilde as the home directory
							--
							shorting_target = 80, -- Shortens path to leave 40 spaces in the window
							-- -- for other components. (terrible name, any suggestions?)
							symbols = {
								modified = "[+]", -- Text to show when the file is modified.
								readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "[New]", -- Text to show for newly created file before first write
							},
						},
					},
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

	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
			}, -- Optional
		},

		config = function()
			require("noice").setup({
				-- You can enable a preset for easier configuration

				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},

				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},

				-- TODO: Customize the notifications
				message = {
					-- Messages shown by lsp servers
					enabled = true,
					view = "notify",
					opts = {},
				},

				--Keymap for noice
				vim.keymap.set(
					"n",
					"<leader>nd",
					":NoiceDismiss<CR>",
					{ silent = true, desc = "[N]otification [D]ismiss" }
				),
			}) -- Enable LSP message handling
			require("notify").setup({
				stages = "fade_in_slide_out", -- Animation style
				timeout = 9000, -- Time in milliseconds before notification disappears
				render = "default", -- Minimal UI for notifications
				fps = 60, -- Smooth animations
				background_colour = "#1e222a", -- Match your theme
				replace = true, -- Replace existing messages
			})
		end,
	},
	-- {
	-- 	"Wansmer/symbol-usage.nvim",
	-- 	event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
	-- 	config = function()
	-- 		local function h(name)
	-- 			return vim.api.nvim_get_hl(0, { name = name })
	-- 		end
	--
	-- 		-- hl-groups can have any name
	-- 		vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
	-- 		vim.api.nvim_set_hl(
	-- 			0,
	-- 			"SymbolUsageContent",
	-- 			{ bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
	-- 		)
	-- 		vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
	-- 		vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
	-- 		vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })
	--
	-- 		local function text_format(symbol)
	-- 			local res = {}
	--
	-- 			local round_start = { "", "SymbolUsageRounding" }
	-- 			local round_end = { "", "SymbolUsageRounding" }
	--
	-- 			-- Indicator that shows if there are any other symbols in the same line
	-- 			local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count)
	-- 				or ""
	--
	-- 			if symbol.references then
	-- 				local usage = symbol.references <= 1 and "usage" or "usages"
	-- 				local num = symbol.references == 0 and "no" or symbol.references
	-- 				table.insert(res, round_start)
	-- 				table.insert(res, { "󰌹 ", "SymbolUsageRef" })
	-- 				table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
	-- 				table.insert(res, round_end)
	-- 			end
	--
	-- 			if symbol.definition then
	-- 				if #res > 0 then
	-- 					table.insert(res, { " ", "NonText" })
	-- 				end
	-- 				table.insert(res, round_start)
	-- 				table.insert(res, { "󰳽 ", "SymbolUsageDef" })
	-- 				table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
	-- 				table.insert(res, round_end)
	-- 			end
	--
	-- 			if symbol.implementation then
	-- 				if #res > 0 then
	-- 					table.insert(res, { " ", "NonText" })
	-- 				end
	-- 				table.insert(res, round_start)
	-- 				table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
	-- 				table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
	-- 				table.insert(res, round_end)
	-- 			end
	--
	-- 			if stacked_functions_content ~= "" then
	-- 				if #res > 0 then
	-- 					table.insert(res, { " ", "NonText" })
	-- 				end
	-- 				table.insert(res, round_start)
	-- 				table.insert(res, { " ", "SymbolUsageImpl" })
	-- 				table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
	-- 				table.insert(res, round_end)
	-- 			end
	--
	-- 			return res
	-- 		end
	--
	-- 		require("symbol-usage").setup({
	-- 			text_format = text_format,
	-- 		})
	-- 	end,
	-- },
}
