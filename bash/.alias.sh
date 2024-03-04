#!/bin/bash
# source program-specific aliases:
for f in ~/.aliases/*; do source "$f"; done

#dotnet core
alias efupdate="dotnet ef database update"
alias efmigrate="dotnet ef migrations add"
alias efremove="dotnet ef migrations remove"
alias dotnetnew="dotnet new webapi -o "
alias nuget-force-clear-cache="nuget locals all -clear && nuget locals all -list | awk '{split($0,a,\": \"); print a[2];}' | xargs rm -rf"

# git
alias gitremovelocalbranches='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias untangle-line-endings='find ./ -type f -exec dos2unix {} \;'
alias undo-commit='git reset --soft HEAD^'

## pacman and trizen
alias aur='trizen --noconfirm'
alias update='trizen --sudo_remove_timestamp=0 --sudo_autorepeat=1 --sudo_autorepeat_at_runtime=1 -Syu --noconfirm'
alias remove-orphans='sudo pacman -Rns $(pacman -Qtdq)'
alias updatekeys='sudo pacman-key --refresh-key'
alias updatemirrors='sudo reflector --latest 20 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist'
alias clean-pacmancache='sudo paccache -rk 1 && sudo paccache -ruk0'
alias clean-trizen-cache='sudo clean-trizen-cache'
alias clean-trash='sudo rm -rf ~/.local/share/Trash/*'
alias clean-journal='sudo journalctl --vacuum-time=2d'
alias clean-pacman-unused='sudo pacman -R $(pacman -Qtdq)'

alias clean-all='clean-pacman-unused && clean-pacmancache && clean-trizen-cache && docker-clean-all && clean-node_modules && clean-journal && clean-trash'

## systeminfo
alias meminfo='free -mth'
alias cpuinfo='lscpu'
alias hddinfo='df -h'
alias temp='watch "sensors | grep Core"'
alias internalip=$'ip route get 8.8.8.8 | awk \'NR==1 {print $NF}\''
alias preferredapps='exo-preferred-applications'

#show 5 most memory consuming apps
alias psmem='ps auxf | sort -nr -k 5 | head -n 5'

# utility
alias nmapscan='nmap -n -sP'
alias wifimenu='nm-connection-editor'
alias findcrlf='find . -path node_modules -prune -o -not -type d -exec file "{}" ";" | grep -E "BOM|CRLF"'
alias fixcrlf='findcrlf > /tmp/crlftolf && cat /tmp/crlftolf | while read line; do CUTLINE=$(echo $line | cut -f1 -d":") && dos2unix $CUTLINE; done'
alias enable-wifi='sudo ip link set wlp2s0 up'
alias scan-wifi='sudo iw dev wlp2s0 scan'
alias pretty-json='python -m json.tool'
alias addpgpkey='gpg --recv-keys'
alias dotnet-install='~/.dotnet-install.sh --install-dir /usr/share/dotnet/ -channel Current -version '
alias mountshares='sudo bash ~/dotfiles/bash/mounts.sh'
alias echo-server='npx http-echo-server'
alias mountcalibre='sudo mount.cifs //10.10.1.11/books /mnt/calibre -o nobrl,user=mastermindzh,noperm,rw'
alias xpid="xprop _NET_WM_PID | cut -d' ' -f3"
alias clean-obj-bin='sudo find . -name "bin" -o -name "obj" -exec rm -rf {} \;'
alias nomachine='/usr/NX/bin/nxplayer'
alias unlockuser='faillock --reset --user'
alias npm-list-links='npm ls -g --depth=0 --link=true'
alias suspend='sudo bash ~/.config/i3/scripts/suspend.sh'
alias clean-all='sudo pacman -R $(pacman -Qtdq) && sudo paccache -rk 1 && sudo paccache -ruk0 && sudo journalctl --vacuum-time=2d && docker-clean-all && rm -rf ~/.local/share/Trash/'
alias delete-empty='find . -type d -empty -delete'
alias addwireguard='sudo nmcli connection import type wireguard file '

# might be useful in demos...
alias oopsie='fuck'

# cli tools
alias crypto='curl -s rate.sx?qF | head -n -2 | tail -n +10'

# show file content without comment lines
alias nocomment='grep -Ev '\''^(#|$)'\'''

# list files/dirs on separate lines
alias list='find ./ -maxdepth 1 -printf "%f\n"'

#show directories
alias dirs='ls -FlA | grep :*/'

#show executables
alias execx='ls -FlA | grep -v \*'

#ls -al
alias la='ls -al'

# show external ip
alias cmyip='curl -s http://ipecho.net/plain; echo'

# File merging
alias pngtopdf="convert *.png"
alias jpgtopdf="convert *.jpg"

## default command fixes :P
alias mkdir='mkdir -p'
alias wget='wget -c'
alias ls='ls -lh --color=auto'
alias installed='sudo pacman -Qetq'
alias aurinstalled='sudo pacman -Qmq'
alias sudo='sudo '
alias markdown-toc='markdown-toc --bullets="-" -i'
alias tree='tree --dirsfirst'
alias handbrake='ghb'
alias cal='cal -mw --color'
alias chrome='google-chrome-stable'
alias teams='teams-insiders --disable-seccomp-filter-sandbox'
alias cat='bat'
alias grep='grep -i'

## command overrides
df() {
  duf
}

# grub
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'

## Functions

# function to cd up a couple of times
# USAGE: up 3 (goes up 3 directories)
up() {
  DEEP=$1
  [ -z "${DEEP}" ] && { DEEP=1; }
  for i in $(seq 1 ${DEEP}); do
    cd ../
  done
}
# function to extract ... well anything really
extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# function to return uptime in a human readable format
myuptime() {
  uptime | awk '{ print "Uptime:", $3, $4, $5 }' | sed 's/,//g'
  return
}

# function to check whether a specific host is up
isup() {
  if ! [ -z "$1" ]; then
    ping -c 3 $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "$1 seems to be offline"
    else
      echo "$1 seems to be online"
    fi
  fi
}

# function to print a line across the screen
printLine() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# function to kill a port
killport() {
  if [ -z "$1" ]; then
    echo "please specify a port to kill"
  else
    fuser -k "$1/tcp"
  fi
}

# merges all pdfs in current directory into a new pdf
mergepdf() {
  if [ -z "$1" ]; then
    echo "please provide an output name for your pdf file: mergepdf out.pdf"
  else
    pdfunite ./*.pdf "$1"
  fi
}

# sign a file using the signing key
signfile() {
  if [ -z "$1" ]; then
    echo "please provide a file to sign: signfile file-to-sign.pdf"
  else
    ssh-keygen -Y sign -f ~/.ssh/signing-key.pub -n file "$1"
  fi
}

alias "set-timezone-romania"='timedatectl set-timezone Europe/Bucharest'
alias "set-timezone-netherlands"=' timedatectl set-timezone Europe/Amsterdam'
