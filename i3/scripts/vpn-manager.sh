#!/bin/bash

# VPN = list con | skip first line, if type == vpn print name | show in rofi
VPN=$(nmcli con | awk 'NR>1 && $3 == "vpn" {print $1}' | rofi -dmenu -p "Select a vpn to (dis)connect")

# if $VPN not set, exit.
[ -z "$VPN" ] && exit

# Check whether vpn is activated
STATE=$(nmcli con show "$VPN" | grep GENERAL.STATE: | awk '{print $2}')

# if state == activated
if [ "$STATE" == "activated" ]; then
    nmcli con down "$VPN"
else
    nmcli con up "$VPN"
fi
