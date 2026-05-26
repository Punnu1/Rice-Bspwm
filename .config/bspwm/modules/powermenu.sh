#!/bin/bash
chosen=$(echo -e "Suspend\nLogout\nReboot\nPoweroff" | rofi -dmenu -theme ~/.config/rofi/themes/Cosmos.rasi -p "System:")

case "$chosen" in
    Suspend) systemctl suspend ;;
    Logout) bspc quit ;;
    Reboot) systemctl reboot ;;
    Poweroff) systemctl poweroff ;;
esac
