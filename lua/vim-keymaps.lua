-- Define the function to handle the logic
local function smart_semicolon_newline()
	local ft = vim.bo.filetype
	-- Save cursor position
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	if ft == "c" or ft == "cpp" then
		-- Add semicolon at end if not already present
		if not line:match(";%s*$") then
			line = line:gsub("%s*$", "") .. ";"

			-- Update line and move to new line
			vim.api.nvim_set_current_line(line)
		end

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

--Create user command for unplug the current model AI
vim.api.nvim_create_user_command("AvanteUnload", function()
	vim.cmd("AvanteStop")

	vim.fn.jobstart("lms ps | grep 'Identifier:' | awk '{print $2}'", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local model = data[1]
			if model and model ~= "" then
				vim.fn.jobstart({ "lms", "unload", model }, {
					on_exit = function()
						print("🔌 Unloaded model: " .. model)
					end,
				})
			else
				print("✅ No model is currently loaded.")
			end
		end,
	})
end, {})
