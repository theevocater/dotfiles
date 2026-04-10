return {
	{ "folke/which-key.nvim", opts = {} },

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "-" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			heading = {
				icons = { "▸ ", "▸▸ ", "▸▸▸ ", "▸▸▸▸ ", "▸▸▸▸▸ ", "▸▸▸▸▸▸ " },
			},
			checkbox = {
				unchecked = { icon = "☐" },
				checked = { icon = "☑" },
			},
		},
	},

	-- Syntax for kovidgoyal/kitty
	{ "fladson/vim-kitty" },
}
