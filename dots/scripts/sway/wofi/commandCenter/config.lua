return = {
  home = os.getenv("HOME")
  
  ["groups"] = {
    ["Waybar"] = {
      ["on"] = function ()
        -- выключение старого waybar и включение нового
        os.execute("killall waybar")
        local config = home .. "/.config/waybar/sway/config2.jsonc"
        local style = home .. "/.config/waybar/sway/stylr.css"
        os.execute("waybar -c" .. config .. " -s " .. style .. " &")
      end,
      ["off"] = function ()
        -- выключение waybar
        os.execute("killall waybar")
      end
    },
    ["System"] = {
      ["warning"] = function (self, prompt, choice_item)
        -- предупреждение пользователя
        local choice_pass = tab
      end,


      ["poweroff"] = function ()
        -- выключение пк
      end,
      ["suspend"] = function ()
        -- превод пк в спящий режим
      end,
      ["display"] = function ()
        -- выключение дисплея
      end
    },
    ["Cpu"] = {
      ["passive"] = function ()
        -- ограничение cpu до 1.4GGz
      end,
      ["active"] = function ()
        -- снятие ограничений на cpu
      end
    }
  }
}