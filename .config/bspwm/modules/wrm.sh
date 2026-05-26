#!/bin/bash

pkill -f "$(basename "$0")"

bspc subscribe desktop_focus | while read -r _ _ _ focused_id; do
    for m in $(bspc query -M); do
        for d in $(bspc query -D -m "$m" -d .empty); do
            d_count=$(bspc query -D -m "$m" | wc -l)
            if [ "$d_count" -gt 1 ] && [ "$d" != "$focused_id" ]; then
                bspc desktop "$d" -r
            fi
        done
    done
done
