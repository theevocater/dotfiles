-------------------------------------------------------------------------------
-- Python Virtualenvs
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	group = vim.api.nvim_create_augroup("PythonVirtualenvAutoActivation", { clear = true }),
	callback = function()
		local venv_paths = { "venv", ".venv" }
		local cwd = vim.fn.getcwd()

		if vim.env.VIRTUAL_ENV then
			local old_venv_bin = vim.env.VIRTUAL_ENV .. "/bin"
			vim.env.PATH = vim.env.PATH:gsub("^" .. vim.pesc(old_venv_bin .. ":"), "")
			vim.env.VIRTUAL_ENV = nil
		end

		for _, venv_name in ipairs(venv_paths) do
			local venv_path = cwd .. "/" .. venv_name
			local python_path = venv_path .. "/bin/python"

			if vim.fn.isdirectory(venv_path) == 1 and vim.fn.executable(python_path) == 1 then
				vim.env.VIRTUAL_ENV = venv_path
				vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
				return
			end
		end
	end,
	desc = "Auto-activate Python virtualenv if present",
})

-------------------------------------------------------------------------------
-- Interface autocmds
-------------------------------------------------------------------------------
-- Show colorcolumn on insert
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec2(
			[[
      let &l:colorcolumn=&textwidth+1
    ]],
			{}
		)
	end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec2([[setlocal colorcolumn=0]], {})
	end,
})

-- see if any files have changed when switching buffers
vim.api.nvim_create_autocmd({ "WinEnter" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec2([[checktime %]], {})
	end,
})

-- if I don't touch anything for 30 seconds, check all buffers
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec2([[checktime]], {})
	end,
})

-- Highlight then clear after yank to make clear what i copied
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
