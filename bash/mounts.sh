#!/bin/bash

# check whether we're running as sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# declare variables
MY_SERVER_LOCATION="//10.10.1.11"
MOUNT_PREFIX="/mnt"

# check whether array contains a key
containsElement() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# trickery to add objects into bash array
# all associative arrays are named NAME{X} where {X} is a number
declare -A MOUNTS0=(
  [server]="$MY_SERVER_LOCATION"
  [share]='Rick'
  [mount]='rick'
)
declare -A MOUNTS1=(
  [server]="$MY_SERVER_LOCATION"
  [share]='Series'
  [mount]='series'
)
declare -A MOUNTS2=(
  [server]="$MY_SERVER_LOCATION"
  [share]='Movies'
  [mount]='movies'
)
declare -A MOUNTS3=(
  [server]="$MY_SERVER_LOCATION"
  [share]='appdata'
  [mount]='appdata'
)
declare -A MOUNTS4=(
  [server]="$MY_SERVER_LOCATION"
  [share]='isos'
  [mount]='isos'
)
declare -A MOUNTS5=(
  [server]="$MY_SERVER_LOCATION"
  [share]='books'
  [mount]='books'
)
declare -A MOUNTS6=(
  [server]="$MY_SERVER_LOCATION"
  [share]='pictures'
  [mount]='pictures'
)
declare -A MOUNTS7=(
  [server]="$MY_SERVER_LOCATION"
  [share]='nvme1'
  [mount]='nvme1'
)
declare -A MOUNTS8=(
  [server]="$MY_SERVER_LOCATION"
  [share]="downloads"
  [mount]="downloads"
)
declare -A MOUNTS9=(
  [server]="$MY_SERVER_LOCATION"
  [share]="emulation"
  [mount]="emulation"
)
declare -A MOUNTS10=(
  [server]="$MY_SERVER_LOCATION"
  [share]="audiobooks"
  [mount]="audiobooks"
)
declare -A MOUNTS11=(
  [server]="$MY_SERVER_LOCATION"
  [share]="games"
  [mount]="games"
)
declare -A MOUNTS12=(
  [server]="$MY_SERVER_LOCATION"
  [share]="data"
  [mount]="data"
)
declare -A MOUNTS13=(
  [server]="$MY_SERVER_LOCATION"
  [share]="vault"
  [mount]="vault"
)
# declare array with "objects"
declare -n MOUNTS

# Show mountpoints and ask user which ones to mount
COUNTER=1
echo "Enter a list of numbers to mount (default = all):"
for MOUNTS in ${!MOUNTS@}; do
  echo "$COUNTER. $MY_SERVER_LOCATION/${MOUNTS[share]} => $MOUNT_PREFIX/${MOUNTS[mount]}"
  ((COUNTER++))
done

# unset and redeclare
unset -n MOUNTS && declare -n MOUNTS

# read user input and add to array of shares to mount
read USER_INPUT
SHARES_TO_MOUNT=()
MOUNT_ALL=false
for number in $USER_INPUT; do
  SHARES_TO_MOUNT+=("$number")
done

# if input is empty -> mount all
if [ "${#SHARES_TO_MOUNT[@]}" == 0 ]; then
  MOUNT_ALL=true
fi

# Run through mounts and execute mounting logic
MOUNTCOUNTER=0
for MOUNTS in ${!MOUNTS@}; do
  ((MOUNTCOUNTER++))

  if [ "$MOUNT_ALL" = true ] || containsElement "$MOUNTCOUNTER" "${SHARES_TO_MOUNT[@]}"; then
    # creating directory
    CURRENT_DIRECTORY="$MOUNT_PREFIX/${MOUNTS[mount]}"
    if [ ! -d "$CURRENT_DIRECTORY" ]; then

      echo -e "\nDirectory '$CURRENT_DIRECTORY' doesn't exist... \nCreating '$CURRENT_DIRECTORY'..."
      mkdir -p "$CURRENT_DIRECTORY"
      echo -e "Created '$CURRENT_DIRECTORY'...\n"
    fi

    # check if directories are mounted already
    if grep -qs "$CURRENT_DIRECTORY " /proc/mounts; then
      echo "$CURRENT_DIRECTORY already mounted"
    else
      # mounting
      SERVER_LOCATION="$MY_SERVER_LOCATION/${MOUNTS[share]}"
      MOUNT_LOCATION="$MOUNT_PREFIX/${MOUNTS[mount]}"

      mount.cifs "$SERVER_LOCATION" "$MOUNT_LOCATION" -o user=mastermindzh,noperm,rw,vers=2.0

      if [ $? -eq 0 ]; then
        echo "Successfully mounted $MOUNT_LOCATION"
      else
        echo "Failed mounting $SERVER_LOCATION on $MOUNT_LOCATION"
      fi
    fi
  fi

done
