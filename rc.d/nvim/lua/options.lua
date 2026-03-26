-------------------------------------------------------------------------------
-- Python provider
-------------------------------------------------------------------------------
vim.g.python3_host_prog = vim.fn.expand("~/.dotfiles/venv/bin/python3")

-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------
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

-- if I don't touch anything for 30 seconds, check all buffers
vim.opt.updatetime = 30000

-- Make yank clipboard work w/ system clipboard. plus is for linux to ensure it uses the copy clipboard not the selection.
-- The use of a function pushes this until after UiEnter which lowers startup time according to https://github.com/nvim-lua/kickstart.nvim/blob/d350db2449da40df003c40d440f909d74e2d4e70/init.lua#L115-L116
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-------------------------------------------------------------------------------
-- Searching
-------------------------------------------------------------------------------
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

-- set up to show spaces
vim.opt.listchars = "tab:>-,trail:_,eol:$,nbsp:␣"

-------------------------------------------------------------------------------
-- Diagnostics
-------------------------------------------------------------------------------
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = true,
	virtual_lines = {
		current_line = true,
	},
	jump = { float = true },
})
