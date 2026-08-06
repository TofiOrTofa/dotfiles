#!/usr/bin/env lua

local function map(tbl, func)
  local out = {}
  for k, v in pairs(tbl) do out[k] = func(v, k) end
  return (out)
end
local function map_values(tbl, func)
  local out = {}
  for k, v in pairs(tbl) do table.insert(out, func(v, k)) end
  return (out)
end


local function freeze (...) local args = table.pack(...)
	return (function () return table.unpack(args, 1, args.n) end)
end

local function configs ()
	local function init_dir (path, value) test(path)
		local keys
		if not value then return (function (val) test(val)
			path = os.getenv("HOME") .. "/.config/river" .. path
			keys = {["path"] = false, ["var"] = true}
				if(type(val) == "string")then
					local result = filter(keys, function (el) return el end)[val]
					test(result); return(result)
				elseif(type(val) == "table")then return init_dir(path, val)
				end; return (init_dir(val))
		end) end
		return (function (key) test(key)
			if key == "path" then return (path)
			elseif key == "value" then return (value)
	end end) end
	local function set (self, variable_name, value) test(variable_name, value)
		self[variable_name] = self[variable_name](value)
	end

	local river = {
		["configs"] = init_dir("/config.d"),
		["templates"] = init_dir("/templates")
	}; local river_paths = map_values(river, function (el)
		return (el("path") .. "?.lua")
	end); package.path = table.concat(river_paths, ";") .. ";" .. package.path

	set(river, "configs", {
		["inputs"] = require("inputs"), ["layouts"] = require("layouts"),
		["keybindings"] = require("binds"), ["autostart"] = require("autostart")
	}); set(river, "templates", {["init"] = require("init")})

	return (function (dir, file) test(dir, file); dir=dir.."s"
		if river[dir] then return (river[dir]("value")[file]) or error() end
	end)
end

init = {};
init.path = river_config_path .. "/init";
init.file = io.open(init.path, 'w');
if not init.file then
  print("Ошибка: Не удалось создать файл по адресу " .. init.path);
  os.exit(1);
end;

-- Вспомогательная функция для сортировки ключей таблицы
local function sorted_keys(elements)
  local keys = {};
  for element, _ in pairs(elements) do
    table.insert(keys, element);
  end;
  table.sort(keys);
  return keys;
end;


local function process_binding(mode, modifier, key, actions)
    -- Если действие всего одно — возвращаем стандартный маппинг
    if #actions == 1 then
        return string.format(
            "riverctl map -layout 0 %s %s %s %s\n",
            mode, modifier, key, actions[1]
        )
    end

    -- Если действий больше одного (Магический макрос):
    -- 1. Генерируем уникальное имя файла для макроса
    local macro_name = string.format("macro_%s_%s_%s", mode, modifier, key:gsub("[^%w]", "_"))

    -- Путь, куда мы сохраним этот макрос (в вашу папку с конфигами river)
    local macros_dir = river_config_path .. "/macros"
    local static_macros_dir = river_static_config_path .. "/macros"

    -- На всякий случай создаем папку для макросов, если её нет
    os.execute("mkdir -p " .. macros_dir)

    local script_path = macros_dir .. "/" .. macro_name .. ".sh"
    local static_script_path = static_macros_dir .. "/" .. macro_name .. ".sh"

    -- Дописываем 'riverctl ' к каждой команде, если его там еще нет
    local formatted_actions = {}
    for _, action in ipairs(actions) do
        action = "riverctl " .. action
        table.insert(formatted_actions, action)
    end

    -- 2. Записываем команды в отдельный исполняемый файл
    local f = io.open(script_path, "w")
    if f then
        f:write("#!/usr/bin/env bash\n") -- Шебанг для баша
        f:write(table.concat(formatted_actions, "\n") .. "\n")
        f:close()
        -- Делаем файл исполняемым (chmod +x)
        os.execute("chmod +x " .. script_path)
    end

    -- 3. Привязываем клавишу к запуску этого созданного файла
    local mapping = string.format(
        "riverctl map -layout 0 %s %s %s spawn %s\n",
        mode, modifier, key, static_script_path
    )

    -- Возвращаем только строку маппинга (в самом init файле кастомных функций больше не будет!)
    return mapping
end



local function generate_binds_section(keybindings)
    local output = {};

    for _, mode in ipairs(sorted_keys(keybindings)) do
        table.insert(output, string.format("\n# %s\n# РЕЖИМ: %s\n# %s\n", string.rep("-", 40), mode:upper(), string.rep("-", 40)));

        for _, modifier in ipairs(sorted_keys(keybindings[mode])) do
            table.insert(output, string.format("# Модификатор: %s\n", modifier));

            for _, key in ipairs(sorted_keys(keybindings[mode][modifier])) do
                -- Вызываем функцию из конфига и получаем таблицу её действий
                local actions = keybindings[mode][modifier][key]();

                -- Пропускаем через наш обработчик макросов
                local bash_code = process_binding(mode, modifier, key, actions);

                table.insert(output, bash_code);
            end;
        end;
    end;
    return table.concat(output, "");
end;


-- 1. шебанг
init.file:write("#!/usr/bin/env bash\n\n");
init.file:write(
  [[dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river]], "\n",
  [[systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP]], "\n",
  "\n\n"
);


-- 2. Базовые системные настройки
init.file:write([[# --- Interface settiongs ---]]);
init.file:write("\n",
  [[riverctl border-width 2]], "\n",
  [[riverctl border-color-focused 0x93a1a1]], "\n",
  [[riverctl border-color-unfocused 0x073642]], "\n",
  [[riverctl set-repeat 50 300]], "\n",
  [[riverctl keyboard-layout -options "grp:caps_toggle" us,ru]], "\n",
  [[riverctl map-pointer normal Super BTN_LEFT move-view]], "\n",
  [[riverctl map-pointer normal Super BTN_RIGHT resize-view]], "\n",
"\n\n");


-- 3. Запись устройств ввода и их настроек
init.file:write([[# --- Inputs settings ---]]);
init.file:write("\n");
local input_devices_name = sorted_keys(inputs);
for _, device_name in ipairs(input_devices_name) do
  init.file:write("\n");
  local commands = sorted_keys(inputs[device_name]);
  for _, command1 in ipairs(commands) do
    local command2 = inputs[device_name][command1];
    local line = string.format(
      'riverctl input "%s" %s %s%s',
      device_name, command1, command2, "\n"
    );
    init.file:write(line);
  end;
end;
init.file:write("\n\n");

-- 4. Запись макетов, и установка дефолта
init.file:write([[# --- Layouts ---]]);
init.file:write("\n\n");
local layouts_name = sorted_keys(layouts);
for _, name in ipairs(layouts_name) do
  local line
  if name ~= "luatile" then
    line = string.format(
      'riverctl spawn %s &%s',
      name, "\n");
  else
    line = 'riverctl spawn river-luatile &\n'
  end;
  init.file:write(line);
end;
for name, value in pairs(layouts) do
  if value.default then
    local line = string.format(
      "riverctl default-layout %s",
      name
    );
    init.file:write(line);
  end;
end;
init.file:write("\n\n");


-- 5. Запуск приложений
init.file:write([[# --- autostart ---]]);
init.file:write("\n\n");
for _, program_name in ipairs(autostart) do
  local line = string.format(
    'riverctl spawn "%s" &%s',
    program_name, "\n"
  );
  init.file:write(line);
end;
init.file:write("\n\n");


-- 6. Объявление кастомных режимов
init.file:write([[# --- mods ---]]);
init.file:write("\n\n");
for mode_name, _ in pairs(keybindings) do
  if mode_name == "normal" then goto normal; end;
  local line = string.format(
    "riverctl declare-mode %s%s",
    mode_name, "\n"
  );
  init.file:write(line);
  ::normal:: ;
end;
init.file:write("\n");


-- 7. запись биндов
local binds_bash_code = generate_binds_section(keybindings)
init.file:write(binds_bash_code)
init.file:close();
