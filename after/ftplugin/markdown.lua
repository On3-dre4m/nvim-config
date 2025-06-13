local set = vim.opt_local

set.textwidth = 90
set.spell = false
set.linebreak = true

vim.wo.colorcolumn = "95"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#73e4f5" })
