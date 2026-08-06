#!/bin/sh

input=$(printf '\n' | wmenu -b -p "Tags")

if [ -z "$input" ]; then
riverctl set-view-tags 511
exit 0
fi

mask=0

for ((i=0; i<${#input}; i++)); do
tag=${input:$i:1}

case "$tag" in
    [1-9])
        mask=$((mask | (1 << (tag - 1))))
        ;;
esac

done

[ "$mask" -ne 0 ] && riverctl set-view-tags "$mask"
