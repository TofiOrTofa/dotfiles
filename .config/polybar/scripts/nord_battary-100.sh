#!/bin/bash

# Находим батарею
if [ -d "/sys/class/power_supply/BAT0" ]; then
    BAT="BAT0"
elif [ -d "/sys/class/power_supply/BAT1" ]; then
    BAT="BAT1"
else
    echo "?[----------------------------------------------------------------------------------------------------]"
    exit 0
fi

capacity=$(cat /sys/class/power_supply/$BAT/capacity 2>/dev/null || echo "0")
status=$(cat /sys/class/power_supply/$BAT/status 2>/dev/null || echo "Unknown")

filled=$capacity
empty=$((100 - filled))

# Цвета
if [ "$status" = "Charging" ]; then
    color="#FC7"
    icon=""
elif [ $capacity -le 20 ]; then
    color="#F00"
    icon=""
else
    color="8BE"
    icon=""
fi

# Создаем полоску из 100 символов
bar=""
if [ $filled -gt 0 ]; then
    bar+="%{F$color}"
    for ((i=0; i<filled; i++)); do bar+="█"; done
fi
#if [ $empty -gt 0 ]; then
#    bar+="%{F$color}"
#    for ((i=0; i<empty; i++)); do bar+=""; done
#    bar+="%{F-}"
#fi
bar+=""
bar+="%{F-}"
#░
echo "$bar" 
# $capacity%
