#!/bin/bash

# Файл, где будем хранить состояние
FLAG_FILE="/tmp/i3_gaps_state"
INNER=10
OUTER=5

if [ ! -f "$FLAG_FILE" ]; then
    # Если файла нет — выключаем отступы и создаем флаг
    i3-msg "gaps inner current set 0; gaps outer current set 0"
    touch "$FLAG_FILE"
else
    # Если файл есть — включаем отступы и удаляем флаг
    i3-msg "gaps inner current set $INNER; gaps outer current set $OUTER"
    rm "$FLAG_FILE"
fi
