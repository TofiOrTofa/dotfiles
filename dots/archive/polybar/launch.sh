#!/bin/bash

# Убить все polybar процессы
killall -q polybar

# Ждем завершения
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Запускаем бар
polybar -c ~/.config/polybar/config.ini first_line &
sleep 0.1
polybar -c ~/.config/polybar/config.ini second_line &
sleep 0.1
polybar -c ~/.config/polybar/config.ini third_line &

echo "Polybar launched!"
