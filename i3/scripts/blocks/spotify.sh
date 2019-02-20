#!/bin/bash

case $BLOCK_BUTTON in
    1) ~/.config/i3/scripts/spotify-cli.sh play ;; # left click
    4) ~/.config/i3/scripts/spotify-cli.sh next ;; # scroll up
    5) ~/.config/i3/scripts/spotify-cli.sh prev ;; # scroll down
esac

if ~/.config/i3/scripts/spotify-cli.sh status | grep 'Paused' > /dev/null; then
    printf ' ' # fa-pause
else
    printf ' ' # fa-play
fi
~/.config/i3/scripts/spotify-cli.sh current-oneline