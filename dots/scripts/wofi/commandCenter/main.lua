#!/usr/bin/env lua
---@diagnostic disable: lowercase-global

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
    ["waybar on"] = function ()
      local config_path = "~/.config/waybar/sway/config2.jsonc"
      local style_path = "~/.config/waybar/sway/style.css"
      os.execute("waybar -c "..config_path.." -s "..style_path.." &")
    end,
    ["waybar off"] = function ()
      os.execute("killall waybar")
    end,
  },
  ["system"] = {
    ["__init__"] = function (self, prompt, choice_item_list)
      local choice_pass = table.concat(choice_item_list, "\n")
      local warning = io.popen(
        "echo '"..choice_pass.."' | wofi".." "..
        "-c".." "..vim_config_path.." "..
        "--dmenu".." "..
        "--prompt".." ".."\""..prompt.."\""
      ); local result = warning:read("*a"):gsub("%s+$", "")
      warning:close()
      return result
    end,
    ["poweroff"] = function (self)
      local prompt = "у тебя умрут все несохранённые проекты"
      local choice_item_list = {"я знаю", "отмена",}
      local res = self:__init__(prompt, choice_item_list)
      if res == "я знаю" then os.execute("poweroff") end
    end,
    ["suspend"] = function (self)
      local prompt = "спокойной ночи"
      local choice_item_list = {"споки-ноки", "я ещё не готов",}
      local res = self:__init__(prompt, choice_item_list)
      if res == "споки-ноки" then os.execute("systemctl suspend") end
    end,
    ["hibernate"] = function (self)
      local prompt = "я постараюсь"
      local choice_item_list = {"я буду за тебя молиться", "лучше не стоит"}
      local res = self:__init__(prompt, choice_item_list)
      if res == "я буду за тебя молиться" then os.execute("systemctl hibernate") end
    end,
  },
  ["cpu"] = {
    ["CPU passive"] = function ()
      --pass
    end,
    ["CPU active"] = function ()
      --pass
    end,
  },
}

local function get_bigrams(str)
    local bigrams = {}
    for i = 1, #str - 1 do
        local pair = str:sub(i, i + 1)
        table.insert(bigrams, {val = pair, pos = i})
    end
    return bigrams
end

local function fuzzy_match_bigrams(input_str, target)
    local radius = 3
    local matches = 0
    
    local input_pairs = get_bigrams(input_str)
    local target_pairs = get_bigrams(target)
    
    local used_target = {}

    for _, ip in ipairs(input_pairs) do
        for j, tp in ipairs(target_pairs) do
            if not used_target[j] then
                local pos_diff = math.abs(ip.pos - tp.pos)
                if ip.val == tp.val and pos_diff <= radius then
                    matches = matches + 1
                    used_target[j] = true
                    break
                end
            end
        end
    end

    local total_pairs = #input_pairs + #target_pairs
    if total_pairs == 0 then return 0, 0 end
    local score = (2 * matches) / total_pairs

    return score, matches
end

-- Ищет наиболее похожее совпадение в списке строк
local function comparison (res, list_items)
  local result_lower = res:lower()
  local best_match = nil
  local max_score = 0.3 -- Минимальный порог схожести

  for _, name_func in ipairs(list_items) do
    local score, _ = fuzzy_match_bigrams(result_lower, name_func:lower())
    if score > max_score then
      max_score = score
      best_match = name_func
    end
  end

  return best_match
end

local function print_wofi(items, prompt_text)
  local items_pass = table.concat(items, "\n")
  local input = io.popen(
    "echo '"..items_pass.."' | wofi".." "..
    "-c".." "..vim_config_path.." "..
    "--dmenu".." "..
    "--prompt \""..(prompt_text or "Выбор").."\""
  ); local result = input:read("*a"):gsub("%s+$", "")
  local _, _, exit_code = input:close()
  return result, exit_code
end

local function main ()
  -- Шаг 1: Выбираем группу (Waybar, System, CPU)
  local group_res, exit_code = print_wofi(choice_item.groups_name, "Категория") 
  if exit_code ~= 0 or group_res == "" then return end

  local matched_group = comparison(group_res, choice_item.groups_name)
  if not matched_group then return end
  
  local group_key = matched_group:lower()
  local sub_items = choice_item.groups[group_key]
  
  -- Шаг 2: Выбираем конкретное действие внутри группы
  local action_res, action_exit = print_wofi(sub_items, matched_group)
  if action_exit ~= 0 or action_res == "" then return end

  local matched_action = comparison(action_res, sub_items)
  if not matched_action then return end

  -- Шаг 3: Запускаем функцию, соответствующую действию
  local target_group = choice_func[group_key]
  if target_group then
    local target_fn = target_group[matched_action]
    if target_fn then
      target_fn(target_group) -- Передаем self на случай если это system функции
    end
  end
end

main()
if ain then ain() end
