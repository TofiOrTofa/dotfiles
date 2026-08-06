#!/usr/bin/env lua

local config_path = os.getenv("HOME") .. "/.dotfiles/configs";
local river_path = config_path .. "/river/config.d";
local wmenu_path = config_path .. "/wmenu";
local paths = {
    config_path .. "/river/config.d/?.lua",
    config_path .. "/wmenu/?.lua",
    package.path
};
package.path = table.concat(paths, ";");
local layouts = require("layouts");

local flag = arg[1] == "--debug" and "debug";

local log
if flag == "debug" then
  log = function(log_mode, ...)
    -- ИСПРАВЛЕНО: Было pring, из-за чего дебаг падал
    print(log_mode, ...);
  end;
else
  log = function(...) end;
end;

local function run_wmenu(items_table, prompt)
    if #items_table == 0 then
        log("[WARNING]", "В функцию run_wmenu передан пустой список!");
        return "";
    end;

    local wmenu_input = table.concat(items_table, "\n");
    local cmd = string.format("echo -e '%s' | wmenu -b -p '%s' 2>&1", wmenu_input, prompt);
    
    log("[INFO]", "Запуск команды:", cmd);
    local handle = io.popen(cmd);
    
    log("[INFO]", "Ожидание ответа от wmenu...");
    local result = handle:read("*a");
    handle:close();
    
    result = result:gsub("^%s*(.-)%s*$", "%1")
    log("[INFO]", "Получен ответ от wmenu:", result);
    return result;
end;

local managers = {};
for name, _ in pairs(layouts) do
    table.insert(managers, name);
end;

log("[INFO]", "Найдено менеджеров в конфиге:", #managers);

local selected_manager = nil;

if #managers == 0 then
    log("[WARNING]", "Конфиг пуст, нечего выбирать.");
    os.exit(0);
elseif #managers == 1 then
    log("[INFO]", "Менеджер всего один. Скипаем первое wmenu. Выбран:", managers[1]);
    selected_manager = managers[1];
else
    selected_manager = run_wmenu(managers, "Выберите менеджер макетов:");
end;

if selected_manager == "" or not layouts[selected_manager] then
    log("[INFO]", "Выход: менеджер не выбран или не существует.");
    os.exit(0);
end;

-- Извлекаем таблицу макетов для выбранного менеджера
local manager_modes = layouts[selected_manager]["modes"] or {};

local layouts_name = {};
for layout_name, _ in pairs(manager_modes) do
    table.insert(layouts_name, layout_name);
end;

log("[INFO]", "Открываю второе меню для выбора макета...");
local selected_layout = run_wmenu(layouts_name, "Выберите макет:");

-- Проверяем, существует ли выбранный макет в таблице ["modes"]
if manager_modes[selected_layout] then
    log("[INFO]", "Запускаю функцию для макета:", selected_layout);
    
    -- Получаем строку команды (например, "main-location left")
    local layout_cmd = manager_modes[selected_layout]()
    
    -- Формируем финальную команду для riverctl
    -- (Форматируем строку через string.format, так как os.execute в Lua не умеет подставлять аргументы как printf)
    local manager_output = string.format("riverctl output-layout %s", selected_manager)
    local system_cmd = string.format("riverctl send-layout-cmd %s '%s'", selected_manager, layout_cmd)
    
    log("[INFO]", "Выполняю команду:", system_cmd)
    os.execute(manager_output);
    os.execute(system_cmd);
else
    log("[INFO]", "Выход: макет не выбран или не существует.");
end;

log("[INFO]", "Скрипт успешно завершил работу");
os.exit(0);

