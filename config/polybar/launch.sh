#!/bin/bash
killall -q polybar

# the battery/adapter device names differ per laptop (BAT0 vs BAT1, ADP1 vs ACAD),
# so look up the internal ones and let modules.ini fall back to its defaults
for supply in /sys/class/power_supply/*; do
  # peripherals such as wireless mice also show up as batteries
  [[ $(cat "$supply/scope" 2>/dev/null) == "Device" ]] && continue

  case "$(cat "$supply/type" 2>/dev/null)" in
  Battery) [[ -z $BATTERY ]] && export BATTERY="${supply##*/}" ;;
  Mains) [[ -z $ADAPTER ]] && export ADAPTER="${supply##*/}" ;;
  esac
done

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
