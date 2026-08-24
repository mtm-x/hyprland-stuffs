#!/usr/bin/env bash
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

wlogout \
    -b 3 \
    -c 0 \
    -r 0 \
    -L 450 \
    -R 450 \
    -T 285 \
    -B 285 \
    --layout "$HOME/.config/wlogout/layout_custom" \
    --css "$HOME/.config/wlogout/style_custom.css" \
    --protocol layer-shell
