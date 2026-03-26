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

require("lazy").setup({ { import = "plugins" } })

require("options")
require("keymaps")
require("autocmds")
require("lsp")
