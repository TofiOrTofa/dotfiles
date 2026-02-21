#!/bin/bash

killall -q polybar

# Создаем минимальный конфиг для теста
cat > /tmp/polybar-test.ini << 'CONFIG'
[settings]
throttle-output = 5

[colors]
background = #1e1e2e
foreground = #cdd6f4

[bar/example]
width = 100%
height = 24pt
background = ${colors.background}
foreground = ${colors.foreground}
modules-left = menu
modules-center = date
modules-right = cpu

[module/menu]
type = custom/menu
format = <label>
label = 🚀

[module/date]
type = internal/date
date = %H:%M:%S

[module/cpu]
type = internal/cpu
interval = 2
format = <label>
label = CPU %percentage%%
CONFIG

# Запускаем
polybar -c /tmp/polybar-test.ini example &
echo "Test bar launched"
