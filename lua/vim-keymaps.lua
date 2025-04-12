-- Define the function to handle the logic
local function smart_semicolon_newline()
	local ft = vim.bo.filetype
	if ft == "c" or ft == "cpp" then
		-- Save cursor position
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_get_current_line()

		-- Add semicolon at end if not already present
		if not line:match(";%s*$") then
			line = line:gsub("%s*$", "") .. ";"
		end

		-- Update line and move to new line
		vim.api.nvim_set_current_line(line)

		vim.api.nvim_win_set_cursor(0, { row, #line + 1 })

		-- Check the current mode
		local mode_info = vim.api.nvim_get_mode()
		local current_mode = mode_info.mode

		if current_mode == "n" then
			vim.api.nvim_command("startinsert")
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", true)
		end
		vim.api.nvim_feedkeys("\n", "n", false)
	else
		-- fallback: just insert new line
		vim.api.nvim_feedkeys("\n", "n", false)
	end
end

-- Set the keymap for normal and insert mode
vim.keymap.set({ "n", "i" }, "<C-n>", smart_semicolon_newline, { noremap = true, silent = true })
