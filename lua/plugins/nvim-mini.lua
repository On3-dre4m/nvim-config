return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			-- NOTE: Text editor
			require("mini.ai").setup({})
			require("mini.surround").setup({})
			require("mini.operators").setup({})
			require("mini.pairs").setup({})
			require("mini.comment").setup({})
			-- NOTE: Workflow

			require("mini.move").setup({})

			-- NOTE: Appearance

			require("mini.notify").setup()

			require("mini.animate").setup({
				scroll = { enable = false },
			})
			-- Add custom behavior for Tab to exit pairs
			vim.keymap.set("i", "<Tab>", function()
				local col = vim.fn.col(".")
				local line = vim.fn.getline(".")
				local char = line:sub(col, col)

				-- Define the characters to jump out of
				local closers = { ")", "]", "}", "'", '"', "`", ">" }

				-- If cursor is on a closing character, move it one step to the right
				if vim.tbl_contains(closers, char) then
					return "<Right>"
				else
					-- Otherwise, insert a Tab
					return "<Tab>"
				end
			end, { expr = true, noremap = true })
		end,
	},
}
