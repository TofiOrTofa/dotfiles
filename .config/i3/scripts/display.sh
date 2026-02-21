#!/bin/bash

# Получаем имя активного монитора (первый подключенный)
MONITOR=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)

# Проверяем текущее состояние монитора
if xrandr --query | grep -A 1 "$MONITOR connected" | grep -q "[0-9]x[0-9]"; then
    # Если разрешение найдено — выключаем
    xrandr --output "$MONITOR" --off
else
    # Если разрешение не указано (монитор off) — включаем
    xrandr --output "$MONITOR" --auto
fi

