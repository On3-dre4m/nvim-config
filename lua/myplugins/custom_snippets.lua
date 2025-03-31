local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.text_node
local f = ls.function_node

-- Function to get the current date in the desired format

local function get_current_date()
	return os.date("%B, %Y") -- e.g., "March 5, 2025"
end

--
ls.add_snippets("all", {

	s(
		"header",
		fmt(
			[[
/*
 * {}
 * 
 *  Created on: {}
 *      Author: {}
 */
#ifndef __{}__
#define __{}__

#ifdef __cplusplus
extern "C" {{
#endif

{}

#ifdef __cplusplus
}}
#endif

#endif // __{}__
                ]],
			{
				-- Automatically get the file name
				f(function()
					return vim.api.nvim_eval('expand("%:t")')
				end), -- Placeholder for the file name
				get_current_date(), -- Current date
				i(1, "PhatLe"), -- Placeholder for the author's name (user input)
				i(2, "HEADER_NAME"), -- Repeat the file name for include guard
				rep(2), -- Repeat the file name for include guard
				i(3), -- Placeholder for additional content (user input)
				rep(2), -- Repeat the file name for include guard
			}
		)
	),
})

--
ls.add_snippets("all", {

	s(
		"header_hw",
		fmt(
			[[
/*
 * {}
 * 
 *  Created on: {}
 *      Author: {}
 */

#ifndef __HW_CONFIG_H__
#define __HW_CONFIG_H__

/* Timer and PWM */
{}

/* ISR */


/* ADC */


/* DRV Gate */


/* Encoder */


/* Misc GPIO */


/* CAN */


/* Hardware constants */


/* Current controller */


#endif // __HW_CONFIG_H__
]],
			{
				f(function()
					return vim.api.nvim_eval('expand("%:t")')
				end), -- Placeholder for the file name
				get_current_date(), -- Current date
				"PhatLe", -- Placeholder for the author's name (user input)
				i(1),
			}
		)
	),
})

ls.add_snippets("all", {
	s(
		"copyright_C",
		fmt(
			[[
/*
 * {}
 * 
 *  Created on: {}
 *      Author: {}
 */
        ]],
			{
				f(function()
					return vim.api.nvim_eval('expand("%:t")')
				end), -- Placeholder for the file name
				get_current_date(), -- Current date
				"PhatLe", -- Placeholder for the author's name (user input)
			}
		)
	),
})

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if ls.jumpable(1) then
		ls.jump(1)
	end
end, { silent = true })
