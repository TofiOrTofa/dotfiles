#!/bin/bash

i3-msg -t subscribe -m '["mode"]' | while read -r event; do
    mode=$(echo "$event" | jq -r '.change')
    
    if [ "$mode" != "default" ]; then
        case $mode in
            "resize") echo "resize" ;;
            *) echo "$mode" ;;
        esac
    else
        echo ""
    fi
done
