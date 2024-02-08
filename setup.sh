#!/bin/bash
docker compose -f ./plex/docker-compose.yml up -d --force-recreate
docker compose -f ./pihole/docker-compose.yml up -d --force-recreate
docker compose -f ./nginx/docker-compose.yml up -d --force-recreate
docker compose -f ./owncloud/docker-compose.yml up -d --force-recreate
docker compose -f ./qbittorrent/docker-compose.yml up -d --force-recreate
