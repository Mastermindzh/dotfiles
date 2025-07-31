#!/bin/bash

# Get workspace information from i3
workspaces_json=$(i3-msg -t get_workspaces)

# Extract active workspaces for each output
notification_text=$(echo "$workspaces_json" | jq -r '.[] | select(.focused == true or .visible == true) | "\(.name) on \(.output | gsub("DisplayPort"; "DP"))"' | sort)

# Show notification with better styling
notify-send -u critical \
  -i workspace \
  -a "i3-workspace-info" \
  -t 10000 \
  -e \
  "Visible workspaces:" "$notification_text"
