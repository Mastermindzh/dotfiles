#!/usr/bin/env bash

icon="$HOME/.config/i3/icons/lock.png"
tmpbg='/tmp/screen.png'

# detect whether tidal is running
isPlaying=$(~/.config/i3/scripts/tidal-cli.sh status)

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

# Stop music if playing
~/.config/i3/scripts/tidal-cli.sh pause

# check whether the lockscreen is being activated because of a suspend
if [[ $* == *--suspend ]]; then
  # if it is, simply lock without no-fork
  i3lock -f -i "$tmpbg"
else
  # if it isn't suspended, enable no-fork
  i3lock -n -f -i "$tmpbg"

  # if tidal was playing before we locked, resume.
  if [ "$isPlaying" == "playing" ]; then
    ~/.config/i3/scripts/tidal-cli.sh play
  fi
  rm -rf $tmpbg
fi
