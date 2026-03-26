return {
	-- Solarized lyfe
	{ -- Load this first to set the background correctly before the theme
		"f-person/auto-dark-mode.nvim",
		priority = 1000,
		opts = {
			fallback = "light",
		},
		config = function(_, opts)
			require("auto-dark-mode").setup(opts)
			vim.cmd.colorscheme("kanagawa")
		end,
		dependencies = {
			{
				"Tsuzat/NeoSolarized.nvim",
				opts = {
					transparent = false,
				},
			},
			{
				"rebelot/kanagawa.nvim",
				opts = {
					compile = false, -- enable compiling the colorscheme
					undercurl = true, -- enable undercurls
					commentStyle = { italic = true },
					functionStyle = {},
					keywordStyle = { italic = true },
					statementStyle = { bold = true },
					typeStyle = {},
					transparent = false, -- do not set background color
					dimInactive = false, -- dim inactive window `:h hl-NormalNC`
					terminalColors = true, -- define vim.g.terminal_color_{0,17}
					colors = { -- add/modify theme and palette colors
						palette = {
							-- Reduce the amount of yellow in the white
							-- lotusWhite0 = "#d5cea3",
							lotusWhite0 = "#dfdeb3",
							-- lotusWhite1 = "#dcd5ac",
							lotusWhite1 = "#dcd5ac",
							-- lotusWhite2 = "#e5ddb0",
							lotusWhite2 = "#e5ddb0",
							-- lotusWhite3 = "#f2ecbc",
							lotusWhite3 = "#fdf6e3",
							-- lotusWhite4 = "#e7dba0",
							lotusWhite4 = "#eee8d5",
							-- lotusWhite5 = "#e4d794",
							lotusWhite5 = "#e9e3c5",
						},
						theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
					},
					overrides = function(colors) -- add/modify highlights
						return {}
					end,
					theme = "lotus",
					background = {
						dark = "wave",
						light = "lotus",
					},
				},
			},
			{
				"EdenEast/nightfox.nvim",
				opts = {
					-- options = {},
					-- palettes = {},
					-- specs = {},
					-- groups = {},
				},
			},
			{ "ellisonleao/gruvbox.nvim" },
			{
				"rose-pine/neovim",
				name = "rose-pine",
			},
			{
				"catppuccin/nvim",
				name = "catppuccin",
				opts = {
					background = { light = "latte", dark = "mocha" },
				},
			},
			{ "nuvic/flexoki-nvim", name = "flexoki" },

			{
				"folke/tokyonight.nvim",
				opts = {},
			},
		},
	},
}
