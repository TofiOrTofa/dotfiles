#!/bin/bash
# touchpad-fix.sh - Исправление остановки курсора у края тачпада

# Ждем загрузки X сервера и тачпада
sleep 2

# Находим тачпад
TOUCHPAD_NAME=$(xinput list --name-only | grep -i "touchpad\|trackpad" | head -1)

if [ -z "$TOUCHPAD_NAME" ]; then
    echo "Тачпад не найден!"
    exit 1
fi

echo "Настраиваю тачпад: $TOUCHPAD_NAME"

# Применяем настройки
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Enabled" 1
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Speed" 100      # Экспериментальное значение
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Friction" 1     # Минимум трения

# Увеличиваем акселерацию
xinput set-prop "$TOUCHPAD_NAME" "libinput Accel Speed" 1.5

# Убедимся, что edge scrolling выключен
xinput set-prop "$TOUCHPAD_NAME" "libinput Scroll Method Enabled" 0, 0, 1

# Включаем tapping (тап вместо клика)
xinput set-prop "$TOUCHPAD_NAME" "libinput Tapping Enabled" 1

# Natural scrolling (как на Mac)
xinput set-prop "$TOUCHPAD_NAME" "libinput Natural Scrolling Enabled" 1

echo "Настройки применены:"
echo "  Coasting Speed: 100"
echo "  Coasting Friction: 1"
echo "  Accel Speed: 1.5"
