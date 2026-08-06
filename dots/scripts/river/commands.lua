#!/usr/bin/env lua

-- 1. Подготовка данных
local options = {
  "off waybar",
  "off displey",
  "poweroff",
  "on waybar",
  "suspend",
  "hibernate",
  "CPU active",
  "CPU passive",
}; local input_str = table.concat(options, "\n")

-- 2. Запуск wofi (запись в stdin и чтение из stdout)
local handle = io.popen("echo '" .. input_str .. "' | wofi -c .config/wofi/config-vim --dmenu --matching=fuzzy")
local choice = handle:read("*a"):gsub("%s+$", "") -- Читаем и убираем лишние пробелы
handle:close()


-- 4. Обработка выбора
if choice == "off waybar" then
  os.execute("killall waybar")
elseif choice == "off displey" then
  os.execute("")
elseif choice == "poweroff" or choice == "suspend" or choice == "hibernate" then
  os.execute("systemctl " .. choice)

elseif choice == "on waybar" then
  os.execute("waybar &")

elseif choice == "CPU active" then
  os.execute("doas tlp ac")
elseif choice == "CPU passive" then
  os.execute("doas tlp bat")
end
