#! /bin/bash

displays=($(xrandr | awk '/ connected /{print $1}'))

if (( ${#displays[@]} > 1 ))
then
    selected_display="$(zenity --list --title 'Select Display' --radiolist --column '' --column 'Display' $(xrandr | awk '/ connected /{print NR,$1}'))"
else
    selected_display="${displays[0]}"
fi

current_brightness=($(xrandr --current --verbose | grep -m1 Brightness | awk '{print $2}' | sed 's/0.//' | sed 's/.0/00/' ))

zenity --scale --title "Set brightness of $selected_display" --value=$current_brightness --print-partial |
while read brightness
do
    xrandr --output "$selected_display" --brightness $(awk '{print $1/100}' <<<"$brightness"})
done