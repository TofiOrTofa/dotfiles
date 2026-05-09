local posix = require("posix")
local socket = require("posix.sys.socket")

local cjson = require("cjson") -- библиотека для десириализации json файлов -- в sway все ивенты в json
local uv = require("luv") -- библиотека для реализации таймеров
local evdev = require("evdev") --библиотука для чтения /dev/input/ -- пользователь должен состоять в группер input

local device_path = "/dev/input/event11"
local device = evdev.Device(device_path)

--local config_path = os.getenv("HOME").."/.config/sway/library_brain.lua"
--local binds_config = dofile(config_path)

local MAGIC = "i3-ipc"
local TYPE_COMMAND = 0
local TYPE_GET_TREE = 4



local function connect_sway()
  local path = os.getenv("SWAYSOCK")
  local sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM, 0)
  socket.connect(sock, { family = socket.AF_UNIX, path = path })
  return sock
end

local function sway_request(sock, msg_type, payload)
  payload = payload or ""
  -- Заголовок: Magic(6) + Len(4) + Type(4)
  local header = string.pack("<c6II", MAGIC, #payload, msg_type)
  socket.send(sock, header .. payload)

  -- читаем ответ
  local res_header = socket.recv(sock, 14)
  local _, len, t = string.unpack("<c6II", res_header)
  return socket.recv(sock, len)
end

local function get_focused_ws_nodes(tree)
  if tree.focused and tree.type == "workspace" then
    return #tree.nodes + #tree.floating_nodes
  end
  for _, node in ipairs(tree.nodes or {}) do
    local res = get_focused_ws_nodes(node)
    if res then return res end
  end
  for _, node in ipairs(tree.floating_nodes or {}) do
    local res = get_focused_ws_nodes(node)
    if res then return res end
  end
end

--local function reload_conf()


-- основная логика

-- Граббим устройство (клавиши не дойдут до системы, пока мы не разрешим)
a = device:grab(true)
print(a);

local modifiers = {
  shift = false,
  ctrl = false,
  super = false, -- right alt тоже евляется super
  alt = false,
}
local sock = connect_sway()
local current_mode = "NORMAL"

local function main()
  while true do
    for event in device:events() do
      if event.type == evdev.EV_KEY then
        if event.code == "KEY_LEFTSHIFT" or event.code == "KEY_RIGHTSHIFT" then
          modifiers.shift = (event.value ~= 0)
        elseif event.code == "KEY_LEFTMETA" or event.code == "KEY_RIGHTALT" then
          modifiers.super = (event.value ~= 0)
        elseif event.code == "KEY_LEFTCTRL" or event.code == "KEY_RIGHTCTRL" then
          modifiers.ctrl = (event.value ~= 0)
        elseif event.code == "KEY_LEFTALT" then
          modifiers.alt = (event.value ~= 0)
        end
        if modes[current_mode][event.code] then
          modes[current_mode][event.code]()
        end
      end
    end
  end
end

-- глобальные пременные и вызов main()

local status, err = pcall(main)

if not status then
  --device:ungrab()
  --notify("brain LuaSway ERROR", "error: "..tostring(err), "critical")
  print("Error: "..err)
end
