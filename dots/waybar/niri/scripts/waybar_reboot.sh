#!/usr/bin/env bash

# Проверяем количество запущенных процессов waybar
count=$(pgrep -c waybar)

if [ $count -gt 0 ]; then
    # Убиваем все процессы waybar
    killall waybar
    # Ждем завершения
    #while pgrep -x waybar > /dev/null; do
    #    sleep 0.1
    #done
else
    # Запускаем waybar с указанием конфига
    waybar -c ~/.config/waybar/config.json &
    #-s ~/.config/waybar/style.css &
fi
