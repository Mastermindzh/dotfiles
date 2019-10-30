#!/bin/bash

TIDAL_HOST="http://localhost:47836"

function httpGet() {
  curl -s "$TIDAL_HOST/$1"
}

function httpSilentGet() {
  curl -s -o /dev/null "$TIDAL_HOST/$1"
}

case $1 in
"play")
  httpSilentGet play
  ;;
"pause")
  httpSilentGet pause
  ;;
"playpause")
  httpSilentGet playpause
  ;;
"next")
  httpSilentGet next
  ;;
"previous")
  httpSilentGet previous
  ;;
"info")
  JSON=$(httpGet current)
  TITLE=$(echo "$JSON" | jq -r '.title')
  ARTISTS=$(echo "$JSON" | jq -r '.artist')
  INFO=$(echo "$TITLE - $ARTISTS")
  if [ ${#INFO} -le 3 ]; then
    echo "No music info available"
  else
    echo "$INFO"
  fi
  ;;
"status")
  if httpGet current | grep "paused" >/dev/null; then
    echo "paused"
  else
    echo "playing"
  fi
  ;;
*)
  echo "tidal-cli doesn't know this command"
  ;;
esac
