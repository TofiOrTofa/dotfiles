#!/bin/bash
# Перезагрузка настроек тачпада

TOUCHPAD_NAME=$(xinput list --name-only | grep -i touchpad | head -1)

# Сброс настроек
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Enabled" 0
sleep 0.5
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Enabled" 1

# Применение наших настроек
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Speed" 100
xinput set-prop "$TOUCHPAD_NAME" "libinput Coasting Friction" 1
xinput set-prop "$TOUCHPAD_NAME" "libinput Accel Speed" 1.5

echo "Настройки тачпада перезагружены"
