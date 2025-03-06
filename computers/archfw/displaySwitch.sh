#!/bin/bash

# Define the layouts
layouts=("undocked" "docked")

# Define the settings for each layout
declare -A undocked_settings=(
  ["Xft.antialias"]="true"
  ["Xft.hinting"]="true"
  ["Xft.rgba"]="rgba"
  ["Xft.hintstyle"]="hintslight"
  ["Xcursor.size"]="50"
  ["Xft.dpi"]="160"
  ["rofi.dpi"]="160"
  ["dpi"]="150"
)

declare -A docked_settings=(
  ["Xft.antialias"]="true"
  ["Xft.hinting"]="true"
  ["Xft.rgba"]="rgba"
  ["Xft.hintstyle"]="hintslight"
  ["Xcursor.size"]="25"
  ["Xft.dpi"]="110"
  ["rofi.dpi"]="110"
  ["dpi"]="110"
)

function updateXSettings() {
  local dpi=$1
  local dpi_value=$((dpi * 1024))
  sed -i -E "/Xft\/DPI/s/[0-9]+/$dpi_value/" ~/.xsettingsd
  killall -HUP xsettingsd
}

function applyLayout() {
  local layout=$1
  case $layout in
  "undocked")
    xrandr --output eDP --primary --mode 2880x1920 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off --output DisplayPort-4 --off --output DisplayPort-5 --off --output DisplayPort-6 --off --output DisplayPort-7 --off
    updateXResources undocked_settings
    updateXSettings ${undocked_settings["dpi"]}
    ;;
  "docked")
    xrandr --output eDP --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DisplayPort-4 --off --output DisplayPort-5 --off --output DisplayPort-6 --off --output DisplayPort-7 --off
    updateXResources docked_settings
    updateXSettings ${docked_settings["dpi"]}
    ;;
  *)
    echo "Unknown layout: $layout"
    exit 1
    ;;
  esac
}

function updateXResources() {
  local -n settings=$1
  true >~/.Xresources
  for key in "${!settings[@]}"; do
    echo "$key: ${settings[$key]}" >>~/.Xresources
  done
  xrdb -merge ~/.Xresources
}

layout=$1
if [ -z "$layout" ]; then
  layout=$(zenity --list --title="Select Monitor Layout" --column="Layout" "${layouts[@]}")
fi

if [ -n "$layout" ]; then
  applyLayout "$layout"
  i3-msg restart
else
  echo "No layout selected."
  exit 1
fi
