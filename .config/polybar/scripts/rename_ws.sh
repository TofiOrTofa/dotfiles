#!/bin/bash

# Получаем индекс (номер) от Polybar
WS_NUM="$1"

# 1. Спрашиваем i3, как СЕЙЧАС называется воркспейс с этим номером
# Это позволяет найти его, даже если там уже есть старое "имя" или мусор
OLD_NAME=$(i3-msg -t get_workspaces | jq -r ".[] | select(.num==$WS_NUM).name")

# 2. Ввод нового текстового имени через Rofi
USER_INPUT=$(echo "" | rofi -dmenu -p "Новое имя для стола $WS_NUM:")

# 3. Если нажали Esc или ввели пустоту — выходим
[ -z "$USER_INPUT" ] && exit 0

# 4. Переименовываем. Используем формат "номер: имя", чтобы работал $mod+номер
i3-msg "rename workspace \"$OLD_NAME\" to \"$WS_NUM: $USER_INPUT\""

