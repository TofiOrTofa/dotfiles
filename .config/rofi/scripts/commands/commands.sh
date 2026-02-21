#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/rofi/scripts/commands/my_commands.conf"

# Проверка наличия файла
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Файл конфигурации не найден!" | rofi -dmenu
    exit 1
fi

# Читаем названия (левая часть до ':')
chosen=$(cut -d':' -f1 "$CONFIG_FILE" | rofi -dmenu -i -p "Действие:")

if [[ -n "$chosen" ]]; then
    # Ищем команду по названию и выполняем
    cmd=$(grep "^$chosen:" "$CONFIG_FILE" | cut -d':' -f2-)
    eval "$cmd" &
fi

