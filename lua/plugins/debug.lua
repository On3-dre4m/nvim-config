return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"jedrzejboczar/nvim-dap-cortex-debug",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here

		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("dapui").setup({})
		require("nvim-dap-virtual-text").setup({
			commented = true,
		})
		local dap_cortex_debug = require("dap-cortex-debug")
		require("dap-cortex-debug").setup({
			debug = false, -- log debug messages
			-- path to cortex-debug extension, supports vim.fn.glob
			-- by default tries to guess: mason.nvim or VSCode extensions
			extension_path = nil,
			lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
			node_path = "/usr/bin/node", -- path to node.js executable
			dapui_rtt = false, -- register nvim-dap-ui RTT element
			-- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
			dap_vscode_filetypes = { "c", "cpp" },
			rtt = {
				buftype = "Terminal", -- 'Terminal' or 'BufTerminal' for terminal buffer vs normal buffer
			},
		})
		-- TODO: config C/C++/Rust Adapter
		dap.adapters.cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = require("mason-registry").get_package("cpptools"):get_install_path()
				.. "/extension/debugAdapters/bin/OpenDebugAD7",

			setupCommands = {
				{
					description = "Enable pretty printing for gdb",
					text = "-enable-pretty-printing",
					ignoreFailures = false,
				},
			},
		}

		dap.configurations.cpp = {
			{
				name = "C/C++/Rust Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtEntry = true,
			},
			{
				name = "C/C++/Rust Attach to gdbserver :1234",
				type = "cppdbg",
				request = "launch",
				MIMode = "gdb",
				miDebuggerServerAddress = "localhost:1234",
				miDebuggerPath = "/usr/bin/gdb",
				cwd = "${workspaceFolder}",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
			},

			-- Configure DAP for STM32 with GDB and OpenOCD
			{
				name = "Example debugging with OpenOCD",
				type = "cortex-debug",
				request = "launch",
				servertype = "openocd",
				serverpath = "openocd",
				gdbPath = "arm-none-eabi-gdb",
				toolchainPath = "/opt/gcc-arm/bin",
				toolchainPrefix = "arm-none-eabi",
				runToEntryPoint = "main",
				swoConfig = { enabled = false },
				showDevDebugOutput = false,
				gdbTarget = "localhost:3333",
				cwd = "${workspaceFolder}",
				executable = function()
					-- Automatically find the .elf file in the build folder
					local elf_file = vim.fn.glob(vim.fn.getcwd() .. "/build/*.elf")

					-- If a file is found, return its path; otherwise, prompt the user
					if elf_file ~= "" then
						return elf_file
					else
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
					end
				end,
				configFiles = {
					-- "/usr/share/openocd/scripts/interface/stlink.cfg", -- Interface config for ST-Link
					-- function()
					-- 	return vim.fn.input(
					-- 		"Path to target config: ",
					-- 		"/usr/share/openocd/scripts/target/stm32",
					-- 		"file"
					-- 	) -- Target config for STM32F4 (replace with your model
					-- end,
					"${workspaceFolder}/openocd/connect.cfg",
				},
			},
		}
		dap.configurations.c = dap.configurations.cpp

		require("dap-python").setup(
			require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python"
		)
		require("dap-python").resolve_python = function()
			-- If a virtual environment is active, use it
			if vim.env.VIRTUAL_ENV then
				return vim.env.VIRTUAL_ENV .. "/bin/python"
			else
				error("❌ No virtual environment detected! Please activate a venv before debugging.")
			end
			-- Otherwise, fallback to system Python
		end

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				-- 'delve',
				"debugpy",
				"cpptools",
			},
		})

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F5>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F7>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })
		vim.keymap.set({ "n", "v" }, "<leader>dh", function()
			require("dap.ui.widgets").hover()
		end, { desc = "Debug: Hover" })
		vim.keymap.set({ "n", "v" }, "<leader>dp", function()
			require("dap.ui.widgets").preview()
		end, { desc = "Debug: Preview" })
		vim.keymap.set("n", "<leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end, { desc = "Debug: Frames" })
		vim.keymap.set("n", "<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, { desc = "Debug: Scopes" })
		vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Debug Repl Open" })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "<F1>", dapui.toggle, { desc = "Debug: See last session result." })

		-- Automatically Open/Close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			vim.schedule_wrap(dapui.open)() -- Ensure UI opens correctly
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			pcall(dapui.close) -- Prevent errors if UI is already closed
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			pcall(dapui.close) -- Prevent errors if UI is already closed
		end -- Install golang specific config
		-- require('dap-go').setup()
	end,
}
