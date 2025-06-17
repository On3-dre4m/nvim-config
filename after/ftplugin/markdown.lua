local set = vim.opt_local

set.textwidth = 90
set.spell = false
set.linebreak = true

vim.cmd("colorscheme tokyonight-moon")

vim.wo.colorcolumn = "95"

vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#73e4f5" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff", bg = "#616360" }) -- Highlight other line numbers
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080", bold = true })
