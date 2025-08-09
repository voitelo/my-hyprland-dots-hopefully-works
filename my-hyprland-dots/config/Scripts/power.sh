#!/bin/bash

chosen=$(printf "Poweroff\nReboot\nSuspend\nLogout\nCancel" | \
  wofi --dmenu --prompt "Power Menu")

case "$chosen" in
  Poweroff) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Logout) hyprctl dispatch exit ;;
  Cancel) exit 0 ;;
esac
