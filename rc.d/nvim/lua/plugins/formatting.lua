return {
	-- Autoformatting
	{ "zapling/mason-conform.nvim", opts = { ignore_install = { "mypy" } } },
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- These are run sequentially
				python = { "reorder-python-imports", "ruff_fix", "ruff_format" },
				go = { "gofmt" },
				-- Use a sub-list to run only the first available formatter
				-- javascript = { { "prettierd", "prettier" } },
			},
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true, proto = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
		},
	},
	-- Supplemental Linters
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				python = (function()
					local linters = { "ruff" }
					-- Only add mypy if its installed (should be in the venv)
					if vim.fn.executable("mypy") == 1 then
						table.insert(linters, "mypy")
					end
					return linters
				end)(),
				go = { "golangcilint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					if vim.opt_local.modifiable:get() then
						require("lint").try_lint()
					end
				end,
			})
		end,
	},
}
