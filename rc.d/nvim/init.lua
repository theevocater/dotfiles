-- Based heavily on my previous vimrc, kickstart.nvim, and lunarvim

-- Change mapleader before anything else so plugins don't accidentally get the
-- wrong ideas
vim.g.mapleader = ' '

-- Use lazy.nvim for package management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    -- Solarized lyfe
    'altercation/vim-colors-solarized',
    priority = 1000,
    config = function()
      vim.opt.background = 'light'
      vim.cmd.colorscheme 'solarized'
    end,
  },

  -- Make vim good thanks to tpope
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-git',
  'tpope/vim-rhubarb',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  { 'folke/which-key.nvim', opts = {} },

  -- replace airblade/vim-gitgutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

})

-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------
-- set noerrorbells
-- set visualbell
-- set t_vb=""

vim.opt.switchbuf = useopen,split

-- Buffer handling
vim.opt.hidden = true
-- adds a ruler to the statusbar
vim.opt.ruler = true

-- sets the title of the xterm or what not to the filename
vim.opt.title = true
-- This allows better matching as it doesn't autochoose
vim.opt.wildmenu = true
-- shell style completion
vim.opt.wildmode = 'list:longest,full'
-- Shows the current mode
vim.opt.showmode = true
-- Shows commands that match your incomplete typing
vim.opt.showcmd =  true
-- Number our lines
vim.o.relativenumber = true
-- always show the statusline
vim.opt.laststatus = 2
-- redraw only when we need to.
vim.opt.lazyredraw = true

-- Statusline
-- TODO this could use an update
vim.api.nvim_exec2([[
function! PasteMode()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction
]], {})

vim.opt.statusline = '%F%m%r%h%w %{fugitive#statusline()}%=%{PasteMode()}[%l,%v][%p%%]'

-- Briefly jump the cursor to show the matching bracket
vim.opt.showmatch = true
vim.opt.matchtime = 3

-- Show the current working line
vim.wo.cursorline = true

-- Show colorcolumn on insert
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2([[
      let &l:colorcolumn=&textwidth+1
    ]], {})
  end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2([[setlocal colorcolumn=0]], {})
  end,
})

-- see if any files have changed when switching buffers
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2([[checktime %]], {})
  end,
})

-- if I don't touch anything for 30 seconds, check all buffers
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2([[checktime]], {})
  end,
})
vim.opt.updatetime = 30000

-- Make yank clipboard work w/ system clipboard
vim.opt.clipboard='unnamed'

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

-------------------------------------------------------------------------------
-- Indenting/Spacing
-------------------------------------------------------------------------------
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth=2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.smartindent = true

-------------------------------------------------------------------------------
-- Line Wrapping
-------------------------------------------------------------------------------
vim.opt.wrap =  true
vim.opt.textwidth = 79
vim.opt.formatoptions = 'jcroql1n'

-------------------------------------------------------------------------------
-- Temp file storage
-------------------------------------------------------------------------------
-- enable backup files
vim.opt.backup =  true
-- By default, backupdir uses '.' which is annoying.
vim.opt.backupdir = vim.fn.expand('~/.local/state/nvim/backup//')

-- enable undofile
vim.opt.undofile = true

-- remember stuff when we close
-- specifically marks, registers, searches and buffers
vim.opt.viminfo = [['20,<50,s10,h,%]]

-- Borrowed from vim9.1.0 defaults.vim
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2([[
    let line = line("'\"")
    if line >= 1 && line <= line("$") && &filetype !~# 'commit' && index(['xxd', 'gitrebase'], &filetype) == -1
      execute "normal! g`\""
    endif
    ]], {})
  end,
})

-- Mappings

-- nmap <silent> <leader>q :silent :nohlsearch<CR>

-- TODO Create mapping to check if darkmode is on


