-- Based heavily on my previous vimrc, kickstart.nvim, and lunarvim

-- Change mapleader before anything else so plugins don't accidentally get the wrong ideas
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use lazy.nvim for package management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Solarized lyfe
	{ -- Load this first to set the background correctly before the theme
		"f-person/auto-dark-mode.nvim",
		priority = 1000,
		opts = {
			fallback = "light",
		},
		config = function()
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

	-- LSP Configuration & Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "mason-org/mason.nvim", config = true },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },
		},
	},

	-- Autoformatting
	{ "zapling/mason-conform.nvim", opts = {} },
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
				python = { "reorder-python-imports" },
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
				python = { "flake8", "mypy" },
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

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",

			-- Adds a number of user-friendly snippets
			"rafamadriz/friendly-snippets",
		},
	},

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

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- This is the main module for opts
		opts = {
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"java",
				"javascript",
				"lua",
				"python",
				"rust",
				"terraform",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},

			auto_install = false,
			sync_install = false,
			ignore_install = {},
			modules = {},

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},
		},
	},

	-- AI Stuff
	{
		"github/copilot.vim",
		config = function()
			-- I want to be able to run copilot manually, but not generate ghost cmps
			vim.cmd(":Copilot disable")
			vim.keymap.set("n", "<leader>cp", function()
				vim.cmd(":Copilot panel")
			end, { desc = "Run [C]o[P]ilot" })
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			chat = {
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
		},
	},

	{
		"stevearc/oil.nvim",
		config = function()
			vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "open [O]il panel" })
		end,
	},
	{
		"MeanderingProgrammer/markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			headings = { "▸ ", "▸▸ ", "▸▸▸ ", "▸▸▸▸ ", "▸▸▸▸▸ ", "▸▸▸▸▸▸ " },
			checkbox = { unchecked = "☐", checked = "☑" },
		},
	},
	-- Syntax for kovidgoyal/kitty
	{ "fladson/vim-kitty" },
})

-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------
-- set noerrorbells
-- set visualbell
-- set t_vb=""

vim.opt.switchbuf = "useopen,split"

-- Buffer handling
vim.opt.hidden = true
-- adds a ruler to the statusbar
vim.opt.ruler = true

-- sets the title of the xterm or what not to the filename
vim.opt.title = true
-- This allows better matching as it doesn't autochoose
vim.opt.wildmenu = true
-- shell style completion
vim.opt.wildmode = "list:longest,full"
-- Shows the current mode
vim.opt.showmode = true
-- Shows commands that match your incomplete typing
vim.opt.showcmd = true
-- Number our lines
vim.o.relativenumber = true
-- always show the statusline
vim.opt.laststatus = 2
-- redraw only when we need to.
vim.opt.lazyredraw = true

-- TODO Enable these?
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true

-- Statusline
-- TODO this could use an update
vim.api.nvim_exec2(
	[[
function! PasteMode()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction
]],
	{}
)

vim.opt.statusline = "%F%m%r%h%w %{fugitive#statusline()}%=%{PasteMode()}[%l,%v][%p%%]"

-- Briefly jump the cursor to show the matching bracket
vim.opt.showmatch = true
vim.opt.matchtime = 3

-- Show the current working line
vim.o.cursorline = true

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

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = true,
	virtual_lines = {
		current_line = true,
	},
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
vim.opt.updatetime = 30000

-- Make yank clipboard work w/ system clipboard. plus is for linux to ensure it uses the copy clipboard not the selection.
-- The use of a function pushes this until after UiEnter which lowers startup time according to https://github.com/nvim-lua/kickstart.nvim/blob/d350db2449da40df003c40d440f909d74e2d4e70/init.lua#L115-L116
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Highlight then clear after yank to make clear what i copied
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-------------------------------------------------------------------------------
-- Searching
-------------------------------------------------------------------------------
-- Use normal regex's
-- nnoremap / /\v
-- vnoremap / /\v
-- Assume case insensitive
vim.opt.ignorecase = true
-- Assume case sensitive in the case of uppercase chars
vim.opt.smartcase = true
-- Best match so far as you type
vim.opt.incsearch = true
-- Highlight the last search done
vim.opt.hlsearch = true

-- Preview s/ubstitions
vim.opt.inccommand = "split"

-------------------------------------------------------------------------------
-- Indenting/Spacing
-------------------------------------------------------------------------------
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-------------------------------------------------------------------------------
-- Line Wrapping
-------------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.textwidth = 119
vim.opt.formatoptions = "jcroql1n"

-------------------------------------------------------------------------------
-- Temp file storage
-------------------------------------------------------------------------------
-- enable backup files
vim.opt.backup = true
-- By default, backupdir uses '.' which is annoying.
vim.opt.backupdir = vim.fn.expand("~/.local/state/nvim/backup//")

-- enable undofile
vim.opt.undofile = true

-- remember stuff when we close
-- specifically marks, registers, searches and buffers
vim.opt.viminfo = [['20,<50,s10,h,%]]

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
-- Leader Hotkeys

-- set up to show spaces
vim.opt.listchars = "tab:>-,trail:_,eol:$,nbsp:␣"
vim.keymap.set("n", "<leader>l", ":set nolist!<CR>", { silent = true })

-- sets ,q to silence search
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- turn on paste quickly
vim.keymap.set("n", "<leader>p", ":set paste!<CR>", { silent = true })

-- remove trailing spaces
vim.keymap.set("n", "<leader>c", ":%s/\\s\\+$//<CR>", { silent = true })

-- TODO Create mapping to check if darkmode is on
--

-------------------------------------------------------------------------------
-- Setup plugins
-------------------------------------------------------------------------------
-- Configure LSP stuff
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("gO", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Opens a popup that displays documentation about the word under your cursor
		--  See `:help K` for why this keymap.
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following autocommand is used to enable inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})
-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	bashls = {},
	clangd = {},
	gopls = {},
	jdtls = {},
	pyright = {},
	rust_analyzer = {},
	terraformls = {},
	ts_ls = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		-- cmd = { ... },
		-- filetypes = { ... },
		-- capabilities = {},
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	ensure_installed = {}, -- Populated via mason-tool-installer
	automatic_enable = true,
	automatic_installation = false,
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

-- Configure nvim-cmp
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "lazydev", group_index = 0 },
		{ name = "luasnip" },
		{ name = "path" },
	}, { { name = "buffer" } }),
})

-- Configure Oil
-- I configure Oil to only replace netrw's directory browsing capabilities, and
-- otherwise leave netrw alone. This ensures things like rhubarb can still
-- function.
require("oil").setup({ default_file_explorer = false })
-- Let oil open directories by default
require("oil.config").setup({ default_file_explorer = true })
-- Turn off the directory browsing part of netrw manually
if vim.fn.exists("#FileExplorer") then
	vim.api.nvim_create_augroup("FileExplorer", { clear = true })
end

-- TODO
-- C-u in telescope
