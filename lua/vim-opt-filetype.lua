vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tex", "plaintex", "latex" }, -- Cover all possible LaTeX filetypes
	callback = function()
		vim.bo.wrap = true
		vim.bo.textwidth = 80
		vim.bo.linebreak = true
		vim.bo.breakat = " ;:,!?"
		vim.bo.display = "lastline"
		vim.notify("LaTeX settings applied for filetype: " .. vim.bo.filetype, vim.log.levels.INFO)
	end,
	desc = "Set LaTeX-specific buffer settings",
})
