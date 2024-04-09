#!/usr/bin/env bash

# check if locked
if ! pgrep -x "i3lock" >/dev/null; then
  echo "not locked, locking"
  bash ~/.config/i3/scripts/lock.sh --suspend
fi

systemctl suspend
