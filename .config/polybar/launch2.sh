#!/bin/bash

# Убить все polybar процессы
killall -q polybar

# Ждем завершения
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Запускаем бар
polybar -c ~/.config/polybar/config_two_bars.ini first &
sleep 0.5
polybar -c ~/.config/polybar/config_two_bars.ini secondary &

echo "Polybar launched!"
