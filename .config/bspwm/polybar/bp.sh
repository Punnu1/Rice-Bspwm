#!/bin/bash

killall -q polybar 

while pgrep -u $UID -x polybar >/dev/null; do 
   sleep 1; 
done

#polybar -c  "$HOME/.config/bspwm/polybar/black" example &
polybar -c  "$HOME/.config/bspwm/polybar/blue" example &
#polybar -c  "$HOME/.config/bspwm/polybar/pink" example &
