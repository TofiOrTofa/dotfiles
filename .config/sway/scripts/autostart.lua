#!/usr/bin/env lua

-- бар --
os.execute("waybar -c ~/.config/waybar/sway/config2.jsonc -s ~/.config/waybar/sway/style.css &")

-- автотайлинг на rust --
os.execute("autotiling-rs &")
os.execute("~/.config/sway/scripts/WindowRule.lua")
