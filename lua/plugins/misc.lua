return {

	{
		-- Hints keybinds
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"epwalsh/pomo.nvim",
		tag = "*",
		lazy = true,
		cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
		opts = {
			-- You can optionally define custom timer sessions.
			notifiers = {
				{
					name = "Default",
					opts = {
						sticky = false,

						-- Configure the display icons:
						title_icon = "󱎫",
						text_icon = "󰄉",
						-- Replace the above with these if you don't have a patched font:
						-- title_icon = "⏳",
						-- text_icon = "⏱️",
					},
				},

				{ name = "System" },
			},
			sessions = {
				-- Example session configuration for a session called "pomodoro".
				pomodoro = {
					{ name = "Work", duration = "50m" },
					{ name = "Short Break", duration = "10m" },
					{ name = "Work", duration = "50m" },
					{ name = "Short Break", duration = "10m" },
					{ name = "Work", duration = "50m" },
					{ name = "Long Break", duration = "15m" },
				},
			},
		},
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

	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			winopts = {
				row = 1,
				height = 1,
			},
			timeout = 1,
			maxkeys = 5,
			-- more opts
			position = "bottom-right",
			show_count = true,
		},
	},
}
