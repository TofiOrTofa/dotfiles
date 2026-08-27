#!/bin/bash

battery_path="/sys/class/power_supply/BAT1"
capacity=$(cat "$battery_path/capacity")
status=$(cat "$battery_path/status")

# Длина полоски (в символах)
bar_length=10

# Рассчитываем количество заполненных символов
filled=$((capacity * bar_length / 100))
empty=$((bar_length - filled))

# Цвета
color_full="#0F0"  # зеленый
color_medium="#FF0" # желтый
color_low="#F00"   # красный
color_empty="#888"  # серый

# Выбираем цвет в зависимости от уровня заряда
if [ $capacity -ge 60 ]; then
    color=$color_full
elif [ $capacity -ge 20 ]; then
    color=$color_medium
else
    color=$color_low
fi

# Создаем полоску
bar=""
for ((i=0; i<filled; i++)); do
    bar+="▰"
done
for ((i=0; i<empty; i++)); do
    bar+="░"
done

# Добавляем иконку статуса
if [ "$status" = "Charging" ]; then
    icon="⚡"
elif [ "$status" = "Full" ]; then
    icon="✓"
else
    icon=""
fi

# Выводим результат
echo "%{F$color}$icon[$bar]%{F-}"
#$capacity%
