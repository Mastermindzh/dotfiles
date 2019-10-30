#!/bin/bash

case $BLOCK_BUTTON in
1) ~/.config/i3/scripts/tidal-cli.sh playpause ;; # left click
4) ~/.config/i3/scripts/tidal-cli.sh next ;; # scroll up
5) ~/.config/i3/scripts/tidal-cli.sh previous ;; # scroll down
esac

if ~/.config/i3/scripts/tidal-cli.sh status | grep 'paused' >/dev/null; then
  printf ' ' # fa-pause
else
  printf ' ' # fa-play
fi
~/.config/i3/scripts/tidal-cli.sh info
