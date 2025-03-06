#! /bin/bash

mapfile -t displays < <(xrandr | awk '/ connected /{print $1}')

if ((${#displays[@]} > 1)); then
  selected_display="$(zenity --list --title 'Select Display' --radiolist --column '' --column 'Display' $(xrandr | awk '/ connected /{print NR,$1}'))"
else
  selected_display="${displays[0]}"
fi

current_brightness=$(xbacklight -display "$selected_display" -get)

zenity --scale --title "Set brightness of $selected_display" --value=$current_brightness --print-partial |
  while read brightness; do
    xbacklight -display "$selected_display" -set "$brightness"
  done
