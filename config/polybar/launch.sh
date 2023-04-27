#!/bin/bash
killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config.ini
PRIMARY=$(xrandr --query | grep -i "connected primary" | cut -d" " -f1)
export MONITOR=$PRIMARY
polybar -r 2>&1 | tee -a /tmp/polybar.log &

# show-bar on all monitors
# idk whether I like this at the moment, I don't really use external displays unless they are the primary or they are duplicated
# if type "xrandr"; then
#   PRIMARY=$(xrandr --query | grep -i "connected primary" | cut -d" " -f1)
#   for m in $(xrandr --query | grep -i " connected" | cut -d" " -f1); do
#     export TRAY_POSITION=none
#     if [[ $m == "$PRIMARY" ]]; then
#       TRAY_POSITION=right
#     fi
#     export MONITOR=$m
#     polybar -r 2>&1 | tee -a /tmp/polybar.log &
#   done
# else
#   polybar -r 2>&1 | tee -a /tmp/polybar.log &
# fi
disown
echo "Polybar launched..."
