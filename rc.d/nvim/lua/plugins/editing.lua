return {
	-- Make vim good thanks to tpope
	"tpope/vim-commentary", -- we might want to look into numToStr/Comment.nvim, tcomment, or others
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>g", ":Git<CR>", { silent = true })
		end,
	},
	"tpope/vim-git",
	"tpope/vim-rhubarb",

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
}
