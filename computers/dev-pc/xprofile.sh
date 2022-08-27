#!/bin/sh
export GDK_DPI_SCALE=1
export ELM_SCALE=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1
xrandr --output DVI-I-0 --off --output DVI-I-1 --off --output HDMI-0 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off --output DVI-D-0 --off
