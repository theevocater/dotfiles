return {
	-- Rich diff/history viewer; works with jj colocated repos since jj uses git storage
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "[G]it [D]iff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[G]it file [H]istory" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "[G]it repo [H]istory" },
		},
		opts = {},
	},

	-- jj-native TUI integration: status, log, describe, etc.
	-- https://github.com/junegun-park/jj.nvim  (early stage, fugitive-style goals)
	-- Uncomment once it matures or you've evaluated it:
	-- {
	-- 	"junegun-park/jj.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	opts = {},
	-- },
}
