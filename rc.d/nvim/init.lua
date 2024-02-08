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
  -- Solarized lyfe
  {
    'altercation/vim-colors-solarized',
    priority = 1000,
    config = function()
      vim.opt.termguicolors = false
      vim.opt.background = 'light'
      vim.cmd.colorscheme 'solarized'
    end,
  },

  -- {
  --    TODO I can't figure out a way to use both this and the classic vim color scheme
  --    depending on termguicolors support so give up for now
  --   'maxmx03/solarized.nvim',
  --   lazy = true,
  -- },

  -- Make vim good thanks to tpope
  'tpope/vim-commentary', -- we might want to look into numToStr/Comment.nvim, tcomment, or others
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
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',

      { "nvimtools/none-ls.nvim", lazy = true },
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

  -- Replace airblade/vim-gitgutter
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

  -- 'github/copilot.vim',
})

-------------------------------------------------------------------------------
-- Interface
-------------------------------------------------------------------------------
-- set noerrorbells
-- set visualbell
-- set t_vb=""

vim.opt.switchbuf = 'useopen,split'

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
vim.opt.showcmd = true
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

-- Make yank clipboard work w/ system clipboard. plus is for linux to ensure it
-- uses the copy clipboard not the selection.
vim.opt.clipboard = 'unnamedplus'

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
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.smartindent = true

-------------------------------------------------------------------------------
-- Line Wrapping
-------------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.textwidth = 79
vim.opt.formatoptions = 'jcroql1n'

-------------------------------------------------------------------------------
-- Temp file storage
-------------------------------------------------------------------------------
-- enable backup files
vim.opt.backup = true
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

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
-- Leader Hotkeys

-- set up to show spaces
vim.opt.listchars = 'tab:>-,trail:_,eol:$'
vim.keymap.set('n', '<leader>s', ':set nolist!<CR>', { silent = true, })

-- sets ,q to silence search
vim.keymap.set('n', '<leader>q', ':nohlsearch<CR>', { silent = true, })

-- turn on paste quickly
vim.keymap.set('n', '<leader>p', ':set paste!<CR>', { silent = true, })

-- remove trailing spaces
vim.keymap.set('n', '<leader>c', ':%s/\\s\\+$//<CR>', { silent = true, })

-- TODO Create mapping to check if darkmode is on
--

-------------------------------------------------------------------------------
-- Setup plugins
-------------------------------------------------------------------------------
-- Setup fugitive
-- open fugitive Git status window
vim.keymap.set('n', '<leader>g', ':Git<CR>', { silent = true, })


-- Setup Telescope
require('telescope').setup {}
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- TODO read telescope docs / kickstart to use more stuff here
vim.keymap.set('n', '<leader>t', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })


-- Setup Treesitter
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'bash',
      'c', 'cpp',
      'go',
      'java',
      'javascript',
      'lua',
      'python',
      'rust',
      'terraform',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
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
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  }
end, 0)

-- Configure LSP stuff
-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  gopls = {},
  jdtls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Go
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.gofmt,

    -- Python
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.black,
  },
})

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}


-- Configure nvim-cmp
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- TODO
-- Ignore venv, etc as old vimrc in fzf etc
-- less annoying autocomplete in comments probably
-- leader motions for formatting the buffer
-- C-u in telescope
