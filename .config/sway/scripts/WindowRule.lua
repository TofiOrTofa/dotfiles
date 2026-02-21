#!/usr/bin/env lua

-- Определяем путь к папке, где лежит сам скрипт
local script_path = debug.getinfo(1).source:match("@(.+)/") or "."
-- Делаем пути абсолютными
package.path = package.path .. ";" .. script_path .. "/share/lua/5.4/?.lua;" .. script_path .. "/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";" .. script_path .. "/lib/lua/5.4/?.so"


local socket = require("socket.unix")
local json = require("cjson")

-- Путь к сокету Sway
local swaysock_path = os.getenv("SWAYSOCK")
if not swaysock_path then
    local handle = io.popen("sway --get-socketpath")
    swaysock_path = handle:read("*a"):gsub("%s+", "")
    handle:close()
end

local client = socket()
assert(client:connect(swaysock_path))

-- Функция для отправки сообщений в Sway IPC
local function sway_msg(type, payload)
    local magic = "i3-ipc"
    local len = #payload
    -- Типы: 0 = RUN_COMMAND, 2 = SUBSCRIBE
    local msg = magic .. string.pack("I4I4", len, type) .. payload
    client:send(msg)
end

-- Подписываемся на события окон
sway_msg(2, json.encode({"window"}))

while true do
    -- Читаем заголовок (14 байт)
    local header = client:receive(14)
    if not header then break end
    
    local magic, len, type = string.unpack("c6I4I4", header)
    local payload = client:receive(len)
    local data = json.decode(payload)

    -- Если фокус перешел на новое окно
    if data.change == "focus" then
        local app_id = data.container.app_id
        -- Укажите app_id вашего терминала (напр. "kitty", "Alacritty", "foot")
        if app_id == "Alacritty" then
            -- Переключаем на раскладку 0 (обычно EN)
            os.execute("swaymsg input type:keyboard xkb_switch_layout 0")
        end
    end
end

