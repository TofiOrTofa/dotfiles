#!/usr/bin/env bash

DIR="$HOME/wallpapers/static"

# Генерируем список полных путей к файлам
# Rofi сопоставит путь к файлу с его эскизом в ~/.cache/thumbnails
selected=$(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | rofi -dmenu -i -p "Выбор обоев" \
    -show-icons \
    -theme-str 'configuration { show-icons: true; }
                element { orientation: vertical; padding: 15px; }
                element-icon { size: 200px; }
                element-text { horizontal-align: 0.5; }
                listview { columns: 4; lines: 2; }')

if [ -n "$selected" ]; then
    feh --bg-fill "$selected"
fi

