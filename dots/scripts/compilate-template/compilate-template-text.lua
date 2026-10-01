#!/usr/bin/env lua

-- Функция раскрытия домашней директории ~
local function expand_user(path)
  if path:sub(1, 1) == "~" then
    local home = os.getenv("HOME") or ""
    return home .. path:sub(2)
  end
  return path
end

-- 1. Проверяем аргументы командной строки
local config_name = arg[1]
if not config_name or config_name == "" then
  io.stderr:write("[ОШИБКА] Не указано имя конфигурации.\n")
  io.stderr:write("Использование: compilate-template-text <имя_конфига> < входной_файл\n")
  os.exit(1)
end

-- 2. Формируем путь к файлу конфигурации
local config_dir = expand_user("~/.config/compilate-template-text")
local config_file_path = config_dir .. "/" .. config_name .. ".lua"

-- 3. Проверяем существование конфига
local config_file = io.open(config_file_path, "r")
if not config_file then
  io.stderr:write("[ОШИБКА] Конфигурация не найдена по пути: " .. config_file_path .. "\n")
  os.exit(1)
else
  config_file:close()
end

-- 4. Загружаем таблицу конфигурации
local status, cfg = pcall(dofile, config_file_path)
if not status or type(cfg) ~= "table" then
  io.stderr:write("[ОШИБКА] Не удалось загрузить конфиг: " .. config_file_path .. "\n")
  io.stderr:write("Причина: " .. tostring(cfg) .. "\n")
  os.exit(1)
end

-- Подготовка окружения. Все ключи из cfg (переменные и функции) будут доступны в {{ ... }}
local env = setmetatable({}, { __index = cfg })

-- 5. Читаем весь текст из stdin
local content = io.read("*all")
if not content then
  os.exit(0) -- Если stdin пустой, просто выходим
end

-- 6. Обрабатываем шаблоны {{ ... }}
content = content:gsub(
  "{{%s*(.-)%s*}}",
  function(code)
    -- Оборачиваем выражение в "return ...", чтобы получить результат
    local chunk_str = "return (" .. code .. ")"

    -- Поддержка разных версий Lua (Lua 5.1 / LuaJIT / Lua 5.2+)
    local chunk, err
    if _VERSION == "Lua 5.1" then
      chunk, err = loadstring(chunk_str)
      if chunk then setfenv(chunk, env) end
    else
      chunk, err = load(chunk_str, "template_expr", "t", env)
    end

    if not chunk then
      io.stderr:write("[ОШИБКА СИНТАКСИСА] {{ " .. code .. " }}. Причина: " .. tostring(err) .. "\n")
      return ""
    end

    -- Выполняем код шаблона
    local success, result = pcall(chunk)
    if success then
      if type(result) == "table" then
        return table.concat(result, "\n") -- если функция вернула массив строк
      end
      return tostring(result ~= nil and result or "")
    else
      io.stderr:write("[ОШИБКА ВЫЧИСЛЕНИЯ] В {{ " .. code .. " }}: " .. tostring(result) .. "\n")
      return ""
    end
  end
)

-- 7. Выводим результат в stdout
io.write(content)

