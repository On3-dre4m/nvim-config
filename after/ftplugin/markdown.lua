local set = vim.opt_local

set.textwidth = 90
set.spell = false
set.linebreak = true
set.wrap = true
set.formatoptions:append("t")

-- local file_dir = vim.fn.expand("%:p:h")
-- if file_dir:lower():gsub("\\", "/"):find("obsidian") then
-- 	vim.cmd("colorscheme catppuccin-mocha")
-- 	local ok, err = pcall(vim.cmd, "colorscheme tokyonight-moon")
-- 	if not ok then
-- 		print("Error loading tokyonight-moon: " .. err)
-- 	end
-- end

vim.keymap.set("n", "<leader>pt", ':set paste<CR>"+p:set nopaste<CR>gqap', {
	buffer = true,
	noremap = true,
	silent = true,
	desc = "Paste and format to textwidth",
})

vim.keymap.set("v", "<C-b>", 'c__<C-r>"__<Esc>', { silent = true })
vim.keymap.set("v", "<C-n>", 'c`<C-r>"`<Esc>', { silent = true })
vim.wo.colorcolumn = "95"

vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#6F4B72" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { bg = "#000000" })
