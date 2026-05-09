return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      -- Переопределяем маппинг Enter:
      -- select = false означает, что выбранный пункт не будет автоматически вставлен
      opts.mappings["<CR>"] = cmp.mapping.confirm({ select = false })
      -- Отключает автоматический показ меню при вводе текста
      opts.completion.autocomplete = false --

      -- Также можно явно отключить автоматическое отображение меню blink.cmp
      opts.completion.menu.auto_show = false
    end,
  },
}
