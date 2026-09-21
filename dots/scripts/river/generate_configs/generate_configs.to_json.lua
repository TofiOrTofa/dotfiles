#!/usr/bin/env lua

-- Функция конвертации таблицы Lua в JSON-строку
local function to_json(val)
    local t = type(val)
    
    -- 1. Обработка базовых типов данных
    if t == "string" then 
        return string.format("%q", val) -- %q автоматически экранирует кавычки и переносы
    elseif t == "number" or t == "boolean" then 
        return tostring(val)
    elseif t == "nil" then 
        return "null"
    elseif t == "table" then
        -- Проверяем, является ли таблица массивом (индексы от 1 до #t)
        local is_array = true
        local count = 0
        for k, _ in pairs(val) do
            count = count + 1
            if type(k) ~= "number" or k < 1 or k > count then
                is_array = false
                break
            end
        end

        -- 2. Сериализация содержимого
        local parts = {}
        if is_array then
            for _, v in ipairs(val) do
                table.insert(parts, to_json(v))
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(val) do
                table.insert(parts, string.format('"%s":%s', tostring(k), to_json(v)))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    else
        return "null" -- Для типов вроде function, thread, userdata
    end
end

local function main(tab)
  return to_json(tab)
end

