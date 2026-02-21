#!/bin/bash

choice=$(echo -e "󰐥 Power Off\n󰜉 Reboot\n󰤄 Suspend\n󰌾 Lock\n󰍃 Logout" | wofi --show dmenu --prompt="Power Menu")

case "$choice" in
    "󰐥 Power Off")
        systemctl poweroff
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰤄 Suspend")
        systemctl suspend
        ;;
    "󰌾 Lock")
        swaylock
        ;;
    "󰍃 Logout")
        swaymsg exit
        ;;
esac
