#!/usr/bin/env lua

-- автотайлинг на rust --
os.execute("autotiling-rs &")

os.execute("~/.config/sway/scripts/windowRules.lua")
