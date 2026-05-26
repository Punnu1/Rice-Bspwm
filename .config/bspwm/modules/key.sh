#!/bin/bash

FILE="$HOME/.config/bspwm/modules/keybinds"

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found."
    exit 1
fi

export LC_ALL=en_US.UTF-8

cat "$FILE" | sed 's/  */ /g' | column -t -s '|' -o '|' | \
rofi -dmenu -i -p " " \
-theme-str 'window { width: 900px; } listview { lines: 15;columns: 2; fixed-height: false; } element { padding: 2px 5px; } element-text { font: "JetBrainsMono Nerd Font 9";text-color: #ffffff; }' 

