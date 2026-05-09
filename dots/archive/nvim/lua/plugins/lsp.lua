return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost" }, -- Запускать линтинг только после сохранения файла
      -- events = { "BufWritePost", "BufReadPost", "BufEnter" }, -- Если нужно и при открытии/входе
    },
  },
}
