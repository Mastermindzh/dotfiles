#!/bin/bash

# start Google Drive client
insync start 

# Wait for the programs to start then remove attention (e.g red blinking)
sleep 1
wmctrl -r "Enpass" -b remove,demands_attention


# Start gkraken if the command exists
if command -v gkraken &> /dev/null
then
    gkraken --hide-window &
fi
