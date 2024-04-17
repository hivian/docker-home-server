#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

servicesEnv="$(printenv "$1")"
IFS=',' read -r -a services <<< "$servicesEnv"

for service in ${services[*]}
do
    cd $service
    docker compose $2 $3 $4
    cd ..
done

# sonarr & radarr root permissions to fix root folder bug
#sudo chown -R 1000:1000 ./sonarr-radar/radarr && sudo chmod 755 -R ./sonarr-radarr/radarr
#sudo chown -R 1000:1000 ./sonarr-radar/sonarr && sudo chmod 755 -R ./sonarr-radarr/sonarr

# Test qbittorrent public ip
# curl ifconfig.IO

# Test gluetun connection
# docker run --rm --network=container:gluetun alpine:3.18 sh -c \"apk add wget && wget -qO- https://ipinfo.io\"
