-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.scrolloff = 20
vim.opt.clipboard = "unnamedplus"
vim.opt.list = false

vim.diagnostic.config({
  virtual_text = false, -- Отключает текст ошибок рядом с кодом
  signs = false, -- Отключает значки ошибок/варнингов в левой колонке
})
vim.diagnostic.enable(false) -- Отключает их полностью при запуске
