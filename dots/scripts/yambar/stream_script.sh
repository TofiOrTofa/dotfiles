#!/bin/sh
stdbuf -oL -eL cat | while read -r line; do
    echo "windows|string|$line"
    echo ""
done

