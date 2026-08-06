Modes = {'NORMAL', 'INSERT', 'RESIZE', 'MICRO'}
Shortcuts = {
  NORMAL = {
    Liders = {'KEY_D'}


    KEY_I = function ()
      current_mode = "INSERT"
      device:ungrab ()
    end,
    KEY_R = function ()
      current_mode = "RESIZE"
    end,
    KEY_M = function ()
      current_mode = "MICRO"
    end,


    KEY_D = {
      KEY_D = function ()
        // поиск приложений
      end,
      KEY_W = function ()
        // список открытых приложений
      end,
    }
  },
  INSERT = {},
  RESIZE = {},
  MICRO = {},
}

return modes
