#!/bin/bash
sleep 2

# Находим тачпад
TOUCHPAD_ID=$(xinput list | grep -i "touchpad" | grep -o 'id=[0-9]*' | cut -d= -f2)

# Проверяем свойства тачпада
echo "Touchpad ID: $TOUCHPAD_ID"
xinput list-props $TOUCHPAD_ID | grep -E "(libinput|Synaptics)"

# ВЫКЛЮЧАЕМ Edge Scrolling - главная причина остановки
xinput set-prop $TOUCHPAD_ID "libinput Scroll Method Enabled" 0, 0, 1
# Только two-finger прокрутка: 0=нет, 0=edge, 1=two-finger

# Включаем coasting (продолжение движения)
xinput set-prop $TOUCHPAD_ID "libinput Coasting Enabled" 1
xinput set-prop $TOUCHPAD_ID "libinput Coasting Speed" 20
xinput set-prop $TOUCHPAD_ID "libinput Coasting Friction" 50

# Настройки как на MacBook
xinput set-prop $TOUCHPAD_ID "libinput Accel Speed" 0.8
xinput set-prop $TOUCHPAD_ID "libinput Accel Profile Enabled" 0, 1
# adaptive профиль: 0=flat, 1=adaptive

# Natural scrolling (прокрутка в противоположную сторону)
xinput set-prop $TOUCHPAD_ID "libinput Natural Scrolling Enabled" 1

# Tapping (тап вместо клика)
xinput set-prop $TOUCHPAD_ID "libinput Tapping Enabled" 1
xinput set-prop $TOUCHPAD_ID "libinput Tapping Button Mapping" 1, 0, 3
# lrm: 1=левая, 0=средняя, 3=правая

# Чувствительность тапа
xinput set-prop $TOUCHPAD_ID "libinput Tapping Drag Lock Enabled" 0

# Отключаем edge motion остановку
xinput set-prop $TOUCHPAD_ID "libinput Send Events Mode Enabled" 0, 1
#xinput set-prop 9 "libinput Scroll Method Enabled" 0, 0, 1
xinput set-prop 9 320 0 0 1
# Важно: разрешаем события даже за краем

# Горизонтальная прокрутка
xinput set-prop $TOUCHPAD_ID "libinput Horizontal Scroll Enabled" 1

# Отключение при печати
xinput set-prop $TOUCHPAD_ID "libinput Disable While Typing Enabled" 0

echo "Touchpad настроен как MacBook!"
