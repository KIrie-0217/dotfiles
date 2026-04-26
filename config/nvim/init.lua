local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- options
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.wo.number = true
vim.opt.timeout = true
vim.opt.timeoutlen = 200
vim.opt.ttimeoutlen = 50
vim.scriptencoding = "utf-8"

-- clipboard (macOS)
if vim.loop.os_uname().sysname == 'Darwin' then
  vim.opt.clipboard:append { 'unnamedplus' }
end

-- fix space key delay in insert mode
vim.api.nvim_set_keymap('i', ' ', ' ', { noremap = true })

require("keymap_vanila")

if vim.g.vscode ~= 1 then
  require("plugins")
  require("keymap_plugins")
  require("lsp_config")
  require("colorscheme")
end
