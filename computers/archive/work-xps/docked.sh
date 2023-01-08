#!/bin/sh
xrandr --output eDP-1 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1-2 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --off --output DP-2 --off --output DP-1-1 --primary --mode 2560x1440 --pos 2560x0 --rotate normal
xrdb -merge ~/.Xresources.docked
