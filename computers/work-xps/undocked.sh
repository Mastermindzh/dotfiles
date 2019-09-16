#!/bin/sh
xrandr --output eDP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DP-1-2 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --off --output DP-2 --off --output DP-1-1 --off
xrdb -merge /home/mastermindzh/.Xresources.undocked
