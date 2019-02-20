#!/bin/bash

# CONSTANTS

SP_VERSION="0.1"
SP_DEST="org.mpris.MediaPlayer2.spotify"
SP_PATH="/org/mpris/MediaPlayer2"
SP_MEMB="org.mpris.MediaPlayer2.Player"

# To get SP_ID and SP_SECRET register at
# https://beta.developer.spotify.com/documentation/general/guides/app-settings/
SP_ID="<yout id>"
SP_SECRET="<your secret>"

# SHELL OPTIONS

shopt -s expand_aliases
SP_B64ID=$(echo -n "$SP_ID:$SP_SECRET"|base64)
SP_B64ID=$(echo $SP_B64ID | sed 's/ //g')

# UTILITY FUNCTIONS

function require {
  hash $1 2>/dev/null || {
    echo >&2 "Error: '$1' is required, but was not found."; exit 1;
  }
}

# COMMON REQUIRED BINARIES

# We need dbus-send to talk to Spotify.
require dbus-send

# Assert standard Unix utilities are available.
require grep
require sed
require cut
require tr

# 'SPECIAL' (NON-DBUS-ALIAS) COMMANDS

function sp-dbus {
  # Sends the given method to Spotify over dbus.
  dbus-send --print-reply --dest=$SP_DEST $SP_PATH $SP_MEMB.$1 ${*:2} > /dev/null
}

function sp-open {
  # Opens the given spotify: URI in Spotify.
  sp-dbus OpenUri string:$1
}

function sp-metadata {
  # Prints the currently playing track in a parseable format.

  dbus-send                                                                   \
  --print-reply                                  `# We need the reply.`       \
  --dest=$SP_DEST                                                             \
  $SP_PATH                                                                    \
  org.freedesktop.DBus.Properties.Get                                         \
  string:"$SP_MEMB" string:'Metadata'                                         \
  | grep -Ev "^method"                           `# Ignore the first line.`   \
  | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' `# Filter interesting fiels.`\
  | sed -E '2~2 a|'                              `# Mark odd fields.`         \
  | tr -d '\n'                                   `# Remove all newlines.`     \
  | sed -E 's/\|/\n/g'                           `# Restore newlines.`        \
  | sed -E 's/(xesam:)|(mpris:)//'               `# Remove ns prefixes.`      \
  | sed -E 's/^"//'                              `# Strip leading...`         \
  | sed -E 's/"$//'                              `# ...and trailing quotes.`  \
  | sed -E 's/"+/|/'                             `# Regard "" as seperator.`  \
  | sed -E 's/ +/ /g'                            `# Merge consecutive spaces.`
}

function sp-current {
  # Prints the currently playing track in a friendly format.
  require column

  sp-metadata \
  | grep --color=never -E "(title)|(album)|(artist)" \
  | sed 's/^\(.\)/\U\1/' \
  | column -t -s'|'
}

function sp-current-oneline {
  sp-metadata | grep -E "(title|artist)" | sed 's/^\(.\)*|//' | sed ':a;N;$!ba;s/\n/ - /g'
}

function sp-status {
  dbus-send \
  --print-reply \
  --dest=$SP_DEST \
  $SP_PATH \
  org.freedesktop.DBus.Properties.Get \
  string:"$SP_MEMB" string:'PlaybackStatus' \
  | tail -1 \
  | cut -d "\"" -f2
}

function sp-eval {
  # Prints the currently playing track as shell variables, ready to be eval'ed
  require sort

  sp-metadata \
  | grep --color=never -E "(title)|(album)|(artist)|(trackid)|(trackNumber)" \
  | sort -r \
  | sed 's/^\([^|]*\)\|/\U\1/' \
  | sed -E 's/\|/="/' \
  | sed -E 's/$/"/' \
  | sed -E 's/^/SPOTIFY_/'
}

function sp-art {
  # Prints the artUrl.

  sp-metadata | grep "artUrl" | cut -d'|' -f2
}

function sp-display {
  # Calls display on the artUrl.

  require display
  display $(sp-art)
}

function sp-feh {
  # Calls feh on the artURl.

  require feh
  feh $(sp-art)
}

function sp-url {
  # Prints the HTTP url.

  TRACK=$(sp-metadata | grep "url" | cut -d'|' -f2 | cut -d':' -f3)
  echo "http://open.spotify.com/track/$TRACK"
}

function sp-clip {
  # Copies the HTTP url.

  require xclip
  sp-url | xclip
}

function sp-http {
  # xdg-opens the HTTP url.

  require xdg-open
  xdg-open $(sp-url)
}

function sp-help {
  # Prints usage information.

  echo "Usage: sp [command]"
  echo "Control a running Spotify instance from the command line."
  echo ""
  echo "  sp play       - Play/pause Spotify"
  echo "  sp pause      - Pause Spotify"
  echo "  sp next       - Go to next track"
  echo "  sp prev       - Go to previous track"
  echo ""
  echo "  sp current    - Format the currently playing track"
  echo "  sp metadata   - Dump the current track's metadata"
  echo "  sp eval       - Return the metadata as a shell script"
  echo ""
  echo "  sp art        - Print the URL to the current track's album artwork"
  echo "  sp display    - Display the current album artwork with \`display\`"
  echo "  sp feh        - Display the current album artwork with \`feh\`"
  echo ""
  echo "  sp url        - Print the HTTP URL for the currently playing track"
  echo "  sp clip       - Copy the HTTP URL to the X clipboard"
  echo "  sp http       - Open the HTTP URL in a web browser"
  echo ""
  echo "  sp open <uri> - Open a spotify: uri"
  echo "  sp search <q> - Start playing the best search result for the given query"
  echo ""
  echo "  sp version    - Show version information"
  echo "  sp help       - Show this information"
  echo ""
  echo "Any other argument will start a search (i.e. 'sp foo' will search for foo)."
}

function sp-search {
  # Searches for tracks, plays the first result.

  require curl
    #send request for token with ID and SecretID encoded to base64->grep take only  token from reply->trim reply down to token-> modified request to include token in header
  Q="$@"
    ST=$(curl -H "Authorization: Basic $SP_B64ID" -d grant_type=client_credentials https://accounts.spotify.com/api/token --silent \
    | grep -E -o "access_token\":\"[a-zA-Z0-9_-]+\"" -m 1 )

   echo $Q

    ST2=${ST:15:86}}
  SPTFY_URI=$( \
    curl -H "Authorization: Bearer $ST2" -s -G --data-urlencode "q=$Q" --data type=artist,track https://api.spotify.com/v1/search/ \
    | grep -E -o "spotify:track:[a-zA-Z0-9]+" -m 1 \
  )

  sp-open $SPTFY_URI
}

function sp-version {
  # Prints version information.

  echo "sp $SP_VERSION"
  echo "Copyright (C) 2013 Wander Nauta"
  echo "License MIT"
}

# 'SIMPLE' (DBUS-ALIAS) COMMANDS

alias sp-play="  sp-dbus PlayPause"
alias sp-pause=" sp-dbus Pause"
alias sp-next="  sp-dbus Next"
alias sp-prev="  sp-dbus Previous"

# DISPATCHER

# First, we connect to the dbus session spotify is on. This isn't really needed
# when running locally, but is crucial when we don't have an X display handy
# (for instance, when running sp over ssh.)

SPOTIFY_PID="$(pidof -s spotify)"

if [[ -z "$SPOTIFY_PID" ]]; then
  echo "Error: Spotify is not running."
  exit 1
fi

QUERY_ENVIRON="$(cat /proc/${SPOTIFY_PID}/environ | tr '\0' '\n' | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
if [[ "${QUERY_ENVIRON}" != "" ]]; then
  export DBUS_SESSION_BUS_ADDRESS="${QUERY_ENVIRON}"
fi

# Then we dispatch the command.

subcommand="$1"

if [[ -z "$subcommand" ]]; then
  # No arguments given, print help.
  sp-help
else
  # Arguments given, check if it's a command.
  if $(type sp-$subcommand > /dev/null 2> /dev/null); then
    # It is. Run it.
    shift
    eval "sp-$subcommand $@"
  else
    # It's not. Try a search.
    eval "sp-search $@"
  fi
fi


# Copyright (C) 2013 Wander Nauta
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software, to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# The software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising from,
# out of or in connection with the software or the use or other dealings in the
# software.
#