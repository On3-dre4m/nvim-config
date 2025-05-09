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

			notes_subdir = "4. NOTE",
			new_notes_location = "notes_subdir",

			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,

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

			attachments = {
				img_folder = "1. RESOURCE/Pics",
			},
			ui = { enable = false },

			wiki_link_func = "use_alias_only",

			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "xdg-open", url }) -- linux
				-- vim.ui.open(url) -- need Neovim 0.10.0+
			end,

			daily_notes = {
				folder = "3. Journal/Daily",
				date_format = "%Y-%m-%d",
				default_tags = { "Log/DailyLog" },
				template = "Daily Note",
			},

			disable_frontmatter = true,
		},
		config = function(_, opts)
			require("obsidian").setup(opts)
			vim.keymap.set(
				"n",
				"<leader>nn",
				"<cmd>ObsidianTOC<cr>",
				{ silent = true, desc = "Obsidian: Table of Content" }
			)

			vim.keymap.set(
				"n",
				"<leader>nt",
				"<cmd>ObsidianTemplate<cr>",
				{ silent = true, desc = "Obsidian: Insert Template" }
			)

			vim.keymap.set(
				"n",
				"<leader>dn",
				"<cmd>ObsidianDailies<cr>",
				{ silent = true, desc = "Obsidian: Daily Notes" }
			)
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_images_as_root = 1
			vim.g.mkdp_images_path = "/mnt/E_Drive/Workplace/Obsidian/Vault/1. RESOURCE/Pics" -- Corrected path format
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

				completions = { blink = { enabled = true } },
				dash = {
					enabled = false,
				},
				latex = { enabled = false },
				heading = {
					icons = {
						"󰬺.",
						"󰬻.",
						"󰬼.",
						"󰬽.",
						"󰬾.",
						"󰬿.",
					},

					width = "block",
					left_pad = 2,
					right_pad = 2,
				},
				paragraph = {
					min_width = 30,
				},
				code = {
					sign = false,
					width = "block",
					left_pad = 2,
					right_pad = 4,
				},

				checkbox = {
					custom = {
						important = {
							raw = "[~]",
							rendered = "󰓎 ",
							highlight = "DiagnosticWarn",
						},
					},
				},
				callout = {
					note = {
						raw = "[!NOTE]",
						rendered = "󰋽 Note",
						highlight = "RenderMarkdownInfo",
						category = "github",
					},
					tip = {
						raw = "[!TIP]",
						rendered = "󰌶 Tip",
						highlight = "RenderMarkdownSuccess",
						category = "github",
					},
					important = {
						raw = "[!IMPORTANT]",
						rendered = "󰅾 Important",
						highlight = "RenderMarkdownHint",
						category = "github",
					},
					warning = {
						raw = "[!WARNING]",
						rendered = "󰀪 Warning",
						highlight = "RenderMarkdownWarn",
						category = "github",
					},
					tldr = {
						raw = "[!TLDR]",
						rendered = "󰨸 Tldr",
						highlight = "RenderMarkdownInfo",
						category = "obsidian",
					},
					info = {
						raw = "[!INFO]",
						rendered = "󰋽 Info",
						highlight = "RenderMarkdownInfo",
						category = "obsidian",
					},
					todo = {
						raw = "[!TODO]",
						rendered = "󰗡 Todo",
						highlight = "RenderMarkdownInfo",
						category = "obsidian",
					},
					success = {
						raw = "[!SUCCESS]",
						rendered = "󰄬 Success",
						highlight = "RenderMarkdownSuccess",
						category = "obsidian",
					},
					check = {
						raw = "[!CHECK]",
						rendered = "󰄬 Check",
						highlight = "RenderMarkdownSuccess",
						category = "obsidian",
					},
					done = {
						raw = "[!DONE]",
						rendered = "󰄬 Done",
						highlight = "RenderMarkdownSuccess",
						category = "obsidian",
					},
					question = {
						raw = "[!QUESTION]",
						rendered = "󰘥 Question",
						highlight = "RenderMarkdownWarn",
						category = "obsidian",
					},
					faq = {
						raw = "[!FAQ]",
						rendered = "󰘥 Faq",
						highlight = "RenderMarkdownWarn",
						category = "obsidian",
					},

					fail = {
						raw = "[!FAIL]",
						rendered = "󰅖 Fail",
						highlight = "RenderMarkdownError",
						category = "obsidian",
					},
					missing = {
						raw = "[!MISSING]",
						rendered = "󰅖 Missing",
						highlight = "RenderMarkdownError",
						category = "obsidian",
					},
					error = {
						raw = "[!ERROR]",
						rendered = "󱐌 Error",
						highlight = "RenderMarkdownError",
						category = "obsidian",
					},
					bug = {
						raw = "[!BUG]",
						rendered = "󰨰 Bug",
						highlight = "RenderMarkdownError",
						category = "obsidian",
					},
					example = {
						raw = "[!EXAMPLE]",
						rendered = "󰉹 Example",
						highlight = "RenderMarkdownHint",
						category = "obsidian",
					},
					quote = {
						raw = "[!QUOTE]",
						rendered = "󱆨 Quote",
						highlight = "RenderMarkdownQuote",
						category = "obsidian",
					},
					cite = {
						raw = "[!CITE]",
						rendered = "󱆨 Cite",
						highlight = "RenderMarkdownQuote",
						category = "obsidian",
					},
				},
				link = {
					enabled = true,
					render_modes = false,
					footnote = {
						enabled = true,
						superscript = true,
						prefix = "",
						suffix = "",
					},
					image = "󰥶 ",
					email = "󰀓 ",
					hyperlink = "󰌹 ",
					highlight = "RenderMarkdownLink",
					wiki = {
						icon = "󱗖 ",
						body = function()
							return nil
						end,
						highlight = "RenderMarkdownWikiLink",
					},
					custom = {
						web = { pattern = "^http", icon = "󰖟 " },
						discord = { pattern = "discord%.com", icon = "󰙯 " },
						github = { pattern = "github%.com", icon = "󰊤 " },
						gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
						google = { pattern = "google%.com", icon = "󰊭 " },
						neovim = { pattern = "neovim%.io", icon = " " },
						reddit = { pattern = "reddit%.com", icon = "󰑍 " },
						stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
						wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
						youtube = { pattern = "youtube%.com", icon = "󰗃 " },
					},
				},
				sign = { enabled = true },
			})
		end,
	},
}
