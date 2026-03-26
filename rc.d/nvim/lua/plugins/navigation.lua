return {
	-- Better netrw, imo
	{
		"stevearc/oil.nvim",
		config = function()
			vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "open [O]il panel" })

			-- Configure Oil to replace netrw's directory browsing capabilities,
			-- but otherwise leave netrw alone so things like rhubarb still work.
			require("oil").setup({ default_file_explorer = true })
			-- Turn off the directory browsing part of netrw manually
			if vim.fn.exists("#FileExplorer") then
				vim.api.nvim_create_augroup("FileExplorer", { clear = true })
			end
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"molecule-man/telescope-menufacture",
		},
		config = function()
			-- Setup Telescope
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
			-- Show hidden files ignoring .git by default
			-- Clone the default Telescope configuration
			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			telescope.setup({
				extensions = {
					["ui_select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				defaults = {
					-- `hidden = true` is not supported in text grep commands.
					vimgrep_arguments = vimgrep_arguments,
				},
				pickers = {
					find_files = {
						-- explicitly ignore .git as you don't normally .gitignore it
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "menufacture")

			local builtin = require("telescope.builtin")
			-- menufacture overrides use <ctrl-^> to enable hidden files etc
			local menufacture = require("telescope").extensions.menufacture
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", menufacture.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", menufacture.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", menufacture.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>gf", menufacture.git_files, { desc = "Search by [G]it [F]iles" })
		end,
	},
}
