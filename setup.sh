#!/bin/bash
docker compose -f ./plex/docker-compose.yml up -d --force-recreate
docker compose -f ./pihole/docker-compose.yml up -d --force-recreate
docker compose -f ./owncloud/docker-compose.yml up -d --force-recreate
docker compose -f ./qbittorrent/docker-compose.yml up -d --force-recreate
docker compose -f ./portainer/docker-compose.yml up -d --force-recreate
docker compose -f ./nginx-proxy/docker-compose.yml up -d --force-recreate

# sonarr & radarr root permissions to fix root folder bug
sudo chown -R 1000:1000 ./sonarr-radar/radarr && sudo chmod 755 -R ./sonarr-radarr/radarr
sudo chown -R 1000:1000 ./sonarr-radar/sonarr && sudo chmod 755 -R ./sonarr-radarr/sonarr

# Test qbittorrent public ip
# curl ifconfig.IO

# Test gluetun connection
# docker run --rm --network=container:gluetun alpine:3.18 sh -c \"apk add wget && wget -qO- https://ipinfo.io\"
