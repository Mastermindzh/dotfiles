#!/usr/bin/env bash

# check if locked
if !(pgrep -x "i3lock" > /dev/null)
then
    bash ~/.config/i3/scripts/i3lock.sh --suspend
fi

systemctl suspend