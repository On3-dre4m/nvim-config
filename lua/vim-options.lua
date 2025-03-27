vim.cmd("set expandtab")
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.swapfile = false -- creates a swapfile
vim.o.smartindent = true -- make indenting smarter again
vim.o.numberwidth = 4 -- set number column width to 2 {default 4}
vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.o.tabstop = 4 -- insert n spaces for a tab
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.o.autoindent = true -- Copy indent from current line when starting new one (default: true)
vim.o.breakindent = true -- Enable break indent (default: false)
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search (default: false)
vim.o.smartcase = true -- Smart case (default: false)

-- Configure cursor appearance
vim.opt.guicursor = {
	"n-v-c:block", -- Normal, Visual, Command mode: block cursor
	"i:ver50-blinkon250-blinkoff250", -- Insert mode: vertical bar, blinking
	"r-cr:hor20", -- Replace mode: horizontal bar
	"o:hor50", -- Operator-pending mode
}
vim.opt.termguicolors = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Keep folds closed by default
vim.opt.foldlevel = 99 -- Open all folds by default

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff" })

vim.keymap.set("n", "<leader>cs", function()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
end, { desc = "Highlight current cursor" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt.conceallevel = 2
	end,
})

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", {})
vim.keymap.set("n", "<Down>", ":resize +2<CR>", {})
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", {})
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", {})

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", {})

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", {})

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', {})

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", {}) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", {}) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", {}) -- close current tab

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v<C-w><C-l>", {}) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s<C-w><C-j>", {}) -- split window horizontally
vim.keymap.set("n", "<leader>wx", ":close<CR>", {}) -- close current split windows

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', {})

--Yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
