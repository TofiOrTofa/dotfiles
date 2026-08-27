#!/bin/bash
sleep 3

# Найти ID тачпада
TOUCHPAD=$(xinput list | grep -i "touchpad" | head -1)
TOUCHPAD_ID=$(echo "$TOUCHPAD" | grep -o 'id=[0-9]*' | cut -d= -f2)

echo "Настройка тачпада: $TOUCHPAD"
echo "ID: $TOUCHPAD_ID"

# Убедиться что используется libinput
CURRENT_DRIVER=$(xinput list-props $TOUCHPAD_ID | grep "Device Driver" | awk -F: '{print $2}')
echo "Текущий драйвер: $CURRENT_DRIVER"

if [[ "$CURRENT_DRIVER" != *"libinput"* ]]; then
    echo "ПРЕДУПРЕЖДЕНИЕ: Используется не libinput драйвер!"
fi

# Принудительно установить все параметры
echo "=== Устанавливаем параметры ==="

# 1. Выключить Edge Scrolling (ГЛАВНОЕ!)
xinput set-prop $TOUCHPAD_ID "libinput Scroll Methods Available" 0, 0, 1
xinput set-prop $TOUCHPAD_ID "libinput Scroll Method Enabled" 0, 0, 1

# 2. Включить Coasting (продолжение движения)
xinput set-prop $TOUCHPAD_ID "libinput Coasting Enabled" 1
xinput set-prop $TOUCHPAD_ID "libinput Coasting Speed" 20
xinput set-prop $TOUCHPAD_ID "libinput Coasting Friction" 40

# 3. Настройки как на Mac
xinput set-prop $TOUCHPAD_ID "libinput Accel Speed" 0.8
xinput set-prop $TOUCHPAD_ID "libinput Accel Profile Enabled" 0, 1

# 4. Natural Scrolling
xinput set-prop $TOUCHPAD_ID "libinput Natural Scrolling Enabled" 1

# 5. Tapping
xinput set-prop $TOUCHPAD_ID "libinput Tapping Enabled" 1
xinput set-prop $TOUCHPAD_ID "libinput Tapping Button Mapping Enabled" 1, 0, 3

# 6. Отключить при печати
xinput set-prop $TOUCHPAD_ID "libinput Disable While Typing Enabled" 1

# 7. Горизонтальная прокрутка
xinput set-prop $TOUCHPAD_ID "libinput Horizontal Scroll Enabled" 1

# 8. Проверить что edge scrolling ВЫКЛЮЧЕН
EDGE_SCROLL=$(xinput list-props $TOUCHPAD_ID | grep "libinput Scroll Methods Available" | awk -F: '{print $2}')
echo "Доступные методы прокрутки: $EDGE_SCROLL"
echo "Только two-finger должен быть включен"

# Вывести текущие настройки
echo "=== Текущие настройки ==="
xinput list-props $TOUCHPAD_ID | grep -E "(Scroll|Coasting|Accel|Natural|Tapping)"

# Сохранить настройки для проверки
xinput list-props $TOUCHPAD_ID > ~/.touchpad-settings.txt
echo "Настройки сохранены в ~/.touchpad-settings.txt"
