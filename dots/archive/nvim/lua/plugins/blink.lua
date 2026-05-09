return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          -- Отключает автоматический показ меню при вводе текста
          auto_show = false,
        },
        ghost_text = {
          -- Также можно отключить "призрачный" текст, если он мешает
          enabled = false,
        },
      },
      -- Если вы хотите, чтобы подсказки появлялись только по нажатию клавиш
      -- (по умолчанию в LazyVim это <C-space>)
      keymap = { preset = "default" },
    },
  },
}
