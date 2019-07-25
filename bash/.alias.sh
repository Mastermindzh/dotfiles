# useful dockers
alias phpserver='docker run --rm -p 2000:80 -v "$PWD":/var/www/html mastermindzh/php-xdebug'
alias nodeserver='docker run --rm -p 3000:3000 -v "$PWD":/app mastermindzh/generic_node'
alias reactserver='docker run --rm -p 8080:8080 -v "$PWD":/app mastermindzh/generic_node'
alias mongoserver='docker run -d --rm -p 27017:27017 --name mongo-server -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=123 -v ~/.db/mongo:/data/db mongo'
alias sqlserver='docker run -d --rm --name sql-server -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Your_Password123" -p 1433:1433 -v ~/.db/mssql:/var/opt/mssql microsoft/mssql-server-linux'

# useful docker commands
alias stop-dockers='docker stop $(docker ps -aq)'
alias docker-clean-containers='docker container prune -f --filter "until=48h"'
alias docker-clean-images='docker image prune -a -f --filter "until=48h"'
alias docker-clean-volumes='docker volume prune -f --filter "label!=keep"'
alias docker-clean-networks='docker network prune -f --filter "until=24h"'
alias docker-clean-all='docker system prune -f --volumes'

#upload text to sprunge.us
#USAGE cat file.txt | sprunge
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

## pacman and trizen
alias aur='trizen --noconfirm'
alias update='trizen -Syyu --noconfirm'
alias updatekeys='sudo pacman-key --refresh-key'
alias clean-pacmancache='sudo paccache -rk 1 && sudo paccache -ruk0'

## systeminfo
alias meminfo='free -mth'
alias cpuinfo='lscpu'
alias hddinfo='df -h'
alias temp='watch "sensors | grep Core"'
alias internalip=$'ip route get 8.8.8.8 | awk \'NR==1 {print $NF}\''
alias preferredapps='exo-preferred-applications'

#show 5 most memory consuming apps
alias psmem='ps auxf | sort -nr -k 5 | head -n 5'

#dotnet core
alias efupdate="dotnet ef database update"
alias efmigrate="dotnet ef migrations add"
alias efremove="dotnet ef migrations remove"
alias dotnetnew="dotnet new webapi -o "

##utility
alias nmapscan='nmap -n -sP'
alias pia='nohup sh /opt/pia/run.sh &>/dev/null & disown'
alias wifimenu='nm-connection-editor'
alias findcrlf='find . -path node_modules -prune -o -not -type d -exec file "{}" ";" | grep -E "BOM|CRLF"'
alias fixcrlf='findcrlf > /tmp/crlftolf && cat /tmp/crlftolf | while read line; do CUTLINE=$(echo $line | cut -f1 -d":") && dos2unix $CUTLINE; done'
alias mountrick='sudo mount -t cifs //192.168.1.2/Rick /mnt/rick/ -o username=mastermindzh,noexec'
alias enable-wifi='sudo ip link set wlp2s0 up'
alias scan-wifi='sudo iw dev wlp2s0 scan'
alias pretty-json='python -m json.tool'
alias addpgpkey='gpg --recv-keys'
alias clean-trash='sudo rm -rf ~/.local/share/Trash/*'
alias clean-journal='sudo journalctl --vacuum-time=2d'
alias clean-all='clean-trash && clean-journal && clean-pacmancache && docker-clean-all'

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

## default command fixes :P
alias mkdir='mkdir -p'
alias wget='wget -c'
alias ls='ls -l --color=auto'
alias installed='sudo pacman -Qetq'
alias aurinstalled='sudo pacman -Qmq'
alias sudo='sudo '
alias markdown-toc='markdown-toc --bullets="-" -i'
alias tree='tree --dirsfirst'
alias handbrake='ghb'

# grub
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'

# git
alias gitremovelocalbranches='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias untangle-line-endings='find ./ -type f -exec dos2unix {} \;'

# development
alias chromecors='google-chrome-stable --disable-web-security --user-data-dir="~/.chrome-unsafe"'



## Functions

# function to cd up a couple of times
# USAGE: up 3 (goes up 3 directories)
up(){ 
    DEEP=$1; 
    [ -z "${DEEP}" ] && { DEEP=1; }; 
    for i in $(seq 1 ${DEEP}); do 
        cd ../; 
    done; 
}
# function to extract ... well anything really
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
} 

# function to return uptime in a human readable format
myuptime () {
    uptime | awk '{ print "Uptime:", $3, $4, $5 }' | sed 's/,//g'
    return;
}

# function to check whether a specific host is up
isup(){
	if ! [ -z "$1" ]; then
		ping -c 3 $1 > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo "$1 Seems to be offline";
		else
            echo "$1 Seems to be online";
        fi
    fi 
}

# function to print a line across the screen
printLine(){
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# function to kill a port
killport () {
    if [ -z "$1" ] ; then
        echo "please specify a port to kill"
    else
        fuser -k $1/tcp
    fi
}
