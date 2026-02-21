#!/bin/bash
NEXT=$(($(i3-msg -t get_workspaces | jq ".[] | select(.focused==true).num") + 1))
i3-msg workspace $NEXT
sleep 0.1
alacritty
