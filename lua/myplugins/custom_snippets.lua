local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.text_node
local f = ls.function_node

ls.add_snippets("all", {

	s(
		"header",
		fmt(
			[[
#ifndef __{}
#define __{}

#ifdef __cplusplus
extern "C" {{
#endif

{}

#ifdef __cplusplus
}}
#endif

#endif // __{}
                ]],
			{
				i(1, "HEADER_NAME"),
				rep(1),
				i(2),
				rep(1),
			}
		)
	),
})

ls.add_snippets("all", {

	s(
		"header_hw",
		fmt(
			[[
#ifndef __HW_CONFIG_H
#define __HW_CONFIG_H

// Timer and PWM

// ISR

// ADC

//  DRV Gate

// Encoder

// Misc GPIO

// CAN

// Hardware constants

// Current controller

#endif // __HW_CONFIG_H
]],
			{}
		)
	),
})

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if ls.jumpable(1) then
		ls.jump(1)
	end
end, { silent = true })
