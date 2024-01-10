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

-- Set mapleader before anything else
vim.g.mapleader = ' '

require('lazy').setup({
-- Solarized lyfe
'altercation/vim-colors-solarized',

-- Make vim good thanks to tpope
'tpope/vim-git',
'tpope/vim-fugitive',
'tpope/vim-rhubarb',

})

-- Colorscheme
vim.opt.background = 'light'

vim.cmd 'colorscheme solarized'

-- Interface
vim.opt.relativenumber = true

vim.opt.showmatch = true
vim.opt.matchtime = 3

vim.opt.cursorline = true

-- Mappings

-- nmap <silent> <leader>q :silent :nohlsearch<CR>

-- Create mapping to check if darkmode is on

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

