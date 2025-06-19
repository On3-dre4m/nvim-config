---@diagnostic disable: undefined-global
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"scottmckendry/telescope-resession.nvim",
			"sharkdp/fd",
		},
		config = function()
			local builtin = require("telescope.builtin")
			-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
			-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [T]ags" })
			-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffer" })
			-- vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "[F]ind [C]olorscheme" })
			--
			vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind Symbols in TREESITTER" })
			vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "[F]ind [S]ymbols" })
			vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, { desc = "[F]ind [I]ncoming Calls" })
			-- vim.keymap.set("n", "<leader>fI", builtin.builtin, { desc = "[F]ind [A]ll Builtin Functions" })
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

			bigfile = { enabled = true },

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

			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
							["J"] = { "preview_scroll_down", mode = { "i", "n" } },
							["K"] = { "preview_scroll_up", mode = { "i", "n" } },
						},
					},
				},
			},
		},

		keys = {
			{
				"<leader>fc",
				function()
					Snacks.picker.colorschemes({
						finder = "vim_colorschemes",
						format = "text",
						preview = "colorscheme",
						preset = "vertical",
						confirm = function(picker, item)
							picker:close()
							if item then
								picker.preview.state.colorscheme = nil
								vim.schedule(function()
									vim.cmd("colorscheme " .. item.text)
								end)
							end
						end,
					})
				end,
				desc = "[F]ind [C]olorschems",
			},

			{
				"<leader>fb",
				function()
					Snacks.picker.buffers({
						finder = "buffers",
						format = "buffer",
						hidden = false,
						unloaded = true,
						current = true,
						sort_lastused = true,
						win = {
							input = {
								keys = {
									["d"] = { "bufdelete", mode = { "n", "i" } },
								},
							},
							list = { keys = { ["d"] = "bufdelete" } },
						},
					})
				end,
				desc = "[F]ind [B]uffers ",
			},

			{
				"<leader>ff",
				function()
					Snacks.picker.files({
						finder = "files",
						format = "file",
						show_empty = true,
						hidden = false,
						ignored = false,
						follow = false,
						supports_live = true,
					})
				end,
				desc = "[F]ind [F]iles ",
			},

			{
				"<leader>fg",
				function()
					Snacks.picker.grep({
						finder = "grep",
						regex = true,
						format = "file",
						show_empty = true,
						live = true, -- live grep by default
						supports_live = true,
					})
				end,
				desc = "[F]ind [G]rep ",
			},

			-- {
			-- 	"<leader>fs",
			-- 	function()
			-- 		Snacks.picker.lsp_symbols({
			-- 			finder = "lsp_symbols",
			-- 			format = "lsp_symbol",
			-- 			tree = true,
			-- 			filter = {
			-- 				default = {
			-- 					"Class",
			-- 					"Constructor",
			-- 					"Enum",
			-- 					"Field",
			-- 					"Function",
			-- 					"Interface",
			-- 					"Method",
			-- 					"Module",
			-- 					"Namespace",
			-- 					"Package",
			-- 					"Property",
			-- 					"Struct",
			-- 					"Trait",
			-- 				},
			-- 				-- set to `true` to include all symbols
			-- 				markdown = true,
			-- 				help = true,
			-- 				-- you can specify a different filter for each filetype
			-- 				lua = {
			-- 					"Class",
			-- 					"Constructor",
			-- 					"Enum",
			-- 					"Field",
			-- 					"Function",
			-- 					"Interface",
			-- 					"Method",
			-- 					"Module",
			-- 					"Namespace",
			-- 					-- "Package", -- remove package since luals uses it for control flow structures
			-- 					"Property",
			-- 					"Struct",
			-- 					"Trait",
			-- 				},
			-- 			},
			-- 		})
			-- 	end,
			-- 	desc = "[F]ind [S]ymbols LSP ",
			-- },
			--
			-- {
			-- 	"<leader>fS",
			-- 	function()
			-- 		Snacks.picker.treesitter({
			-- 			finder = "treesitter_symbols",
			-- 			format = "lsp_symbol",
			-- 			tree = true,
			-- 			filter = {
			-- 				default = {
			-- 					"Class",
			-- 					"Enum",
			-- 					"Field",
			-- 					"Function",
			-- 					"Method",
			-- 					"Module",
			-- 					"Namespace",
			-- 					"Struct",
			-- 					"Trait",
			-- 				},
			-- 				-- set to `true` to include all symbols
			-- 				markdown = true,
			-- 				help = true,
			-- 			},
			-- 		})
			-- 	end,
			-- 	desc = "[F]ind  TREESITTER  [S]ymbols LSP ",
			-- },
			--
			-- {
			-- 	"<leader>fw",
			-- 	function()
			-- 		Snacks.picker.lsp_workspace_symbols(vim.tbl_extend("force", {}, M.lsp_symbols, {
			-- 			workspace = true,
			-- 			tree = false,
			-- 			supports_live = true,
			-- 			live = true, -- live by default
			-- 		}))
			-- 	end,
			-- 	desc = "[F]ind [W]orkspace Symbols LSP ",
			-- },

			{
				"<leader>fm",
				function()
					Snacks.picker.marks({
						finder = "vim_marks",
						format = "file",
						global = true,
						["local"] = true,
					})
				end,
				desc = "[F]ind [M]arks",
			},

			{
				"<leader>fI",
				function()
					Snacks.picker.pickers({
						finder = "meta_pickers",
						format = "text",
						confirm = function(picker, item)
							picker:close()
							if item then
								vim.schedule(function()
									Snacks.picker(item.text)
								end)
							end
						end,
					})
				end,
				desc = "[F]ind SNACKS.PICKER built-in func",
			},
		},
	},
}
