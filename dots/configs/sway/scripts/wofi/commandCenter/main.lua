---@diagnostic disable: lowercase-global
#!/usr/bin/env lua

local vim_config_path = "~/.config/wofi/config-vim"
local choice_item = {
  ["groups_name"] = {
    "Waybar",
    "System",
    "CPU",
  },
  ["groups"] = {
    ["waybar"] = { "waybar on", "waybar off", },
    ["system"] = { "poweroff", "suspend", "hibernate", },
    ["cpu"] = { "CPU active", "CPU passive",},
  }
}

local choice_func = {
  ["waybar"] = {
    ["on"] = function ()
      local config_path = "~/.config/waybar/sway/config2.jsonc"
      local style_path = "~/.config/waybar/sway/style.css"
      os.execute("waybar -c "..config_path.." -s "..style_path.." &")
    end,
    ["off"] = function ()
      os.execute("killall waybar")
    end,
  },
  ["system"] = {
    ["__init__"] = function (self, prompt, choice_item)
      -- предупреждение пользователя
      local choice_pass = table.concat(choice_item, "\n")
      local warning = io.popen(
        "echo '"..choice_pass.."' | wofi".." "..
        "-c".." "..vim_config_path.." "..
        "--no-actions".." "..
        "--prompt".." ".."\""..prompt.."\""
      ); local result = warning:read("*a"):grub("%s+$", "")
    end,
    ["poweroff"] = function (self)
      local prompt = "у тебя умрут все несохранённые проекты"
      local choice_item = {"я знаю", "отмена",}
      self.__init__(prompt, choice_item)
    end,
    ["suspend"] = function (self)
      local prompt = "спокойной ночи"
      local choice_item = {"споки-ноки", "я ещё не готов",}
      self.__init__(prompt, choice_item)
    end,
    ["hibernate"] = function (self)
      local prompt = "я постараюсь"
      local choice_item = {"я буду за тебя молиться", "лучше не стоит"}
      self.__init__(prompt, choice_item)
    end,
  },
  ["cpu"] = {
    ["passive"] = function ()
      --pass
    end,
    ["active"] = function ()
      --pass
    end,
  },
  ["display"] = {
    switch_powition = true,
    ["__init__"] = function (self, prompt, choice_item)
      if not switch_position then
        local comeback = (io.popen(
          "echo 'hello world!' | wofi".." "..
          "-c".." "..vim_config_path.." "..
          "--no-actions"
        )):read("*a"):grub("%s+$","")
        return true
      else
        local choice_pass = table.concat(choice_item, "\n")
        local warning = io.popen(
          "echo '"..choice_pass.."' | wofi".." "..
          "-c".." "..vim_config_path.." "..
          "--no-actions".." "..
          "--prompt".." ".."\""..prompt.."\""
        ); local result = warning:read("*a"):grub("%s+$", "")
        return result
      end
    end,
    ["off_warning"] = function (self)
      local switch_position = true
      local prompt = "ты уверен?"
      local choice_item = {"yes", "no",}
      local result = self.__init__(prompt, choice_item)
      if result == "yes" then
        self.off()
      else
        os.exit()
      end

    end,
    ["off"] = function (self)
      os.execute("swaymsg output eDP-1 disable"); switch_position = false
      switch_position = self.__init__()
    end,
    ["on"] = function (self)
      os.execute("swaymsg output eDP-1 enable")
    end
  },
}

local function get_bigrams(str)
    local bigrams = {}
    -- Проходим по строке и берем пары: (1,2), (2,3), (3,4)...
    for i = 1, #str - 1 do
        local pair = str:sub(i, i + 1)
        table.insert(bigrams, {val = pair, pos = i})
    end
    return bigrams
end

local function fuzzy_match_bigrams(input, target)
    local radius = 3
    local matches = 0
    
    local input_pairs = get_bigrams(input)
    local target_pairs = get_bigrams(target)
    
    local used_target = {} -- Чтобы не считать одну пару дважды

    for _, ip in ipairs(input_pairs) do
        -- Ищем совпадение пары в пределах радиуса
        for j, tp in ipairs(target_pairs) do
            if not used_target[j] then
                -- Проверяем: совпадает ли текст пары И находится ли она в радиусе
                local pos_diff = math.abs(ip.pos - tp.pos)
                
                if ip.val == tp.val and pos_diff <= radius then
                    matches = matches + 1
                    used_target[j] = true
                    break
                end
            end
        end
    end

    -- Рассчитываем процент схожести (коэффициент Дайса)
    -- Чем ближе к 1, тем больше похоже
    local total_pairs = #input_pairs + #target_pairs
    local score = (2 * matches) / total_pairs

    return score, matches
end


local function comparison (result, groups)
  local result = input:lower(result)
  local found = {}
  for _, list_func in pairs(groups) do
    for _, name_func in ipairs(list_func) do
      local score, _ = fuzzy_match_bigrams(result, input:lower(name_func))
      if score > 0.3 then
        found[name_func] = {list_func, score}
      end
    end
  end
  if found == {} then
    return false
  else
    local score = 0
    local result = {}
    local count = 1
    for name_func, other in found do
      local score_now = other[2]
      if score_now>=score then
        result[count] = name_func

      end

    end
  end
end

local function print_wofi(items)
  local items_pass = table.concat(items, "\n")
  local input = io.popen(
    "echo '"..choice_pass(choice_item.groups_name)"' | wofi".." "..
    "-c".." "..vim_config_path.." "..
    "--exec-search".." "..
    "--search '%s'".." "..
    "--print-selection".." "..
    "--key-accept1=Control_L-Return".." "..
    "--key-accept2=Control_R-Return"
  ); local result = input:read("*a"):gsub("%s+$", "")
  local _, _, exit_code = input:close()
  return result, exit_code
end

local function main ()
  local result, exit_code = print_wofi(choice_item.groups_name) 
  if exit_code == 0 then
    comparison(result, chice_item.groups)
  elseif exit_code == 10 or exit_code == 20 then
    --pass
  end
end

main()
