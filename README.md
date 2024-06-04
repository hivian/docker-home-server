# Docker Home Server

A self-hosted homeserver setup.

Even though being only used on your local network it uses ```https``` via a wildcard certificate for every service. You can still access from all around the world via a VPN e.g. Wireguard. Traefik is the reverse proxy for all the services.

![Homepage](https://raw.githubusercontent.com/hivian/docker-home/master/dashboard.png)

## Prerequisites

- Server running docker
- [Cloudflare](https://www.cloudflare.com/) Domain
- DNS A-record pointing to your main server ip (e.g. 192.168.1.2)
- Wildcard CNAME record for your services, pointing to your A-record domain
- Docker compose files make use of environment variables. ```mv .env.template .env``` in root folder and subfolders, then update variables accordingly

## Initial Setup

Run 
```
docker network create traefik-network
./docker-compose.sh ACTIVE_SERVICES up -d
```

## Dashboard

The default dashboard is [homepage from benphelps](https://github.com/benphelps/homepage) (```./homepage```). Most services are already configured to appear on the dashboard when they are up and running.

## Services

| **Application**                 | **Description**                      |                                  
|---------------------------------|--------------------------------------|
| [Jellyfin](https://jellyfin.org/) | Handles the work of serving media files to various player clients
| [Jellyseerr](https://github.com/Fallenbagel/jellyseerr) | Request management UI and media discovery tool for Jellyfin, Sonarr & Radarr ecosystem
| [Sonarr](https://sonarr.tv) | Automatically searches for torrents for TV series, watches for new episodes
| [Radarr](https://radarr.video) | Automatically searches for torrents for Movies                                              
| [Bazarr](https://www.bazarr.media/) | Companion application to Sonarr and Radarr that manages and downloads subtitles                                                                        
| [Prowlarr](https://prowlarr.com/) | Proxy for various tracker sites. Takes queries from Sonarr/Radarr and translates them into tracker-site-specific queries and relays responses  
| [Gluetun](https://github.com/qdm12/gluetun) | VPN client to any VPN service providers
| [QBittorrent](https://www.qbittorrent.org/) | BitTorrent client with a web interface. Handles downloads given by Sonarr/Radarr. Use Gluetun network for privacy.
| [Homepage](https://gethomepage.dev)| Home services dashboard
| [Traefik](https://traefik.io)| Reverse proxy. Configures itself automatically and dynamically via labels in Docker
| [Pihole](https://pi-hole.net/)  |  Network-wide software for blocking ads & tracking
| [Unbound](https://github.com/MatthewVance/unbound-docker)  |  Recursive and caching DNS server. Listen only for queries from Pi-hole
| [Home Assistant](https://www.home-assistant.io/) | Home automation
| [Nextcloud](https://nextcloud.com/) | Open source data storage and synchronization system
| [Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) | Internet performance tracking application
| [Portainer](https://www.portainer.io/) | Simplifies Docker container management


