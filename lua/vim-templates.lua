local M = {}

function M.insert_header_template()
	local filename = vim.fn.expand("%:t") -- Get the current file name
	local include_guard_symbol = filename:gsub("%.", "_"):upper() -- Create include guard from filename
	local date = os.date("%b %d, %Y") -- Get the current date
	local username = os.getenv("USER") -- Get the current username

	-- Insert the template
	local template = string.format(
		[[
/*
 * %s
 * Created on: %s
 * Author: %s
 */

#ifndef %s
#define %s

// Includes
#include <stdio.h>  // Example include, modify as needed

// Declarations
// Add your declarations here

#endif /* %s */
]],
		filename,
		date,
		username,
		include_guard_symbol,
		include_guard_symbol,
		include_guard_symbol
	)

	vim.api.nvim_put({ template }, "l", true, true)
end

-- Set up the autocommand for new header files
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "*.h", "*.hpp" },
	callback = function()
		M.insert_header_template()
	end,
})

return M
