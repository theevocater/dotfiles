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

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim',       opts = {} },
    },
  },
  -- Autoformatting
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- These are run sequentially
        python = { "reorder-python-imports", "black" },
        go = { "gofmt" },
        -- Use a sub-list to run only the first available formatter
        -- javascript = { { "prettierd", "prettier" } },
      },
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },
  -- Linting
  { 'mfussenegger/nvim-lint' },

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

  { 'folke/which-key.nvim',  opts = {} },

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
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      -- Setup Telescope
      require('telescope').setup {
        extensions = {
          ['ui_select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  'github/copilot.vim',
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
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
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
  bashls = {},
  clangd = {},
  gopls = {},
  jdtls = {},
  pyright = {},
  rust_analyzer = {},
  terraformls = {},
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

require('lint').linters_by_ft = {
  python = { 'flake8', 'mypy' },
  go = { 'golangcilint' },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })
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
