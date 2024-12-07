#!/usr/bin/bash

#Set default terminal emulator
TERMINAL_APP=xfce4-terminal
CUSTOM_SCRIPTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/custom"

function execInTerminal {
  $TERMINAL_APP -H -e "$1"
}

function getExtraActions {
  local custom_scripts=""
  if [ -d "$CUSTOM_SCRIPTS_DIR" ]; then
    for file in "$CUSTOM_SCRIPTS_DIR"/*; do
      custom_scripts="$custom_scripts\n$(basename "$file")"
    done
  fi
  echo "$custom_scripts"
}

selected_container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.ID}}" | sed '1d' | rofi -p "🥡 Running containers " -dmenu)
container_options_attach="Attach"
container_options_stop="Stop"
container_options_logs="Logs"
container_options_restart="Restart"

if [[ ! -z $selected_container ]]; then
  container_id=$(echo "$selected_container" | awk '{ print $3}')
  container_name=$(echo "$selected_container" | awk '{ print $1}')

  selected_action=$(echo -e "$container_options_attach\n$container_options_logs\n$container_options_restart\n$container_options_stop$(getExtraActions)" | rofi -dmenu -selected-row 0)
  case $selected_action in
  "$container_options_attach")
    execInTerminal "docker exec -it ${container_id} /bin/sh"
    ;;
  "$container_options_restart")
    msg=$(docker restart "$container_id")
    rofi -e "Message from the docker: $msg"
    ;;
  "$container_options_logs")
    execInTerminal "docker logs -f ${container_id}"
    ;;
  "$container_options_stop")
    msg=$(docker stop "$container_id")
    rofi -e "Message from the docker: $msg"
    ;;
  *)
    bash "$CUSTOM_SCRIPTS_DIR/$selected_action" "$container_name"
    ;;
  esac
fi
