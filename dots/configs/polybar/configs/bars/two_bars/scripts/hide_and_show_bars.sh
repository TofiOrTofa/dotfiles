#!/bin/bash

if pgrep -x polybar >/dev/null; then
  killall -p polybar
else
  ~/.config/polybar/launch2.sh
fi
