return {
  ["rivercarro"] = {
    ["default"] = false,


    ["modes"] = {
      -- ИСПРАВЛЕНО: для rivercarro команда пишется как "layout monocle"
      ["monocle"] = function()
        return [[layout monocle]];
      end,
      -- Можно добавить и обычный грид/тайл для rivercarro, если нужно:
      ["tile"] = function()
        return [[layout tile]];
      end
    }
  },
  ["rivertile"] = {
    ["default"] = false,

    ["modes"] = {
      ["tile"] = function()
        return [[main-location left]];
      end
    }
  },
  ["luatile"] = {
    ["default"] = true,

    ["modes"] = {
      ["fixed-scroll"] = function()
        return [[start()]];
      end
    }
  }
}

