#!/bin/bash
# useful docker commands
alias stop-dockers='docker stop $(docker ps -aq)'
alias docker-clean-containers='docker container prune -f --filter "until=48h"'
alias docker-clean-images='docker image prune -a -f --filter "until=48h"'
alias docker-clean-volumes='docker volume prune -f --filter "label!=keep"'
alias docker-clean-networks='docker network prune -f --filter "until=24h"'
alias docker-clean-all='stop-dockers && docker-clean-containers && docker-clean-images && docker-clean-volumes && docker-clean-networks'

# useful dockers
alias phpserver='docker run --rm -p 2000:80 -v "$PWD":/var/www/html mastermindzh/php-xdebug'
alias nodeserver='docker run --rm -p 3000:3000 -v "$PWD":/app mastermindzh/generic_node'
alias reactserver='docker run --rm -p 8080:8080 -v "$PWD":/app mastermindzh/generic_node'
alias mongoserver='docker run -d --rm -p 27017:27017 --name mongo-server -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=123 -v ~/.db/mongo:/data/db mongo'
alias sqlserver='docker run --rm --name sql-server -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Your_Password123" -p 1433:1433 -v ~/.db/mssql:/var/opt/mssql mcr.microsoft.com/mssql/server'
alias mailcatcher='docker run -d -p 1080:1080 -p 1025:1025 --name mailcatcher schickling/mailcatcher'
