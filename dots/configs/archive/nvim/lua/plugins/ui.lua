return {
  -- Отключаем линии отступов в snacks.nvim (новый стандарт LazyVim)
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },
  -- Отключаем старый плагин indent-blankline (если он активен)
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  -- Отключаем анимацию области отступов (вертикальная линия при движении)
  {
    "nvim-mini/mini.indentscope",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
  {
    "windwp/nvim-ts-autotag",
    enabled = false,
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
