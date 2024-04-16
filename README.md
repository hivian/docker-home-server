# Homeserver

A robust and extensible homeserver setup.

It is designed to be hosted and used only on your local network. 
Even though being only used on my local network it uses ```https``` via a wildcard certificate for everything.
I can still access from all around the world via Wireguard VPN.
Traefik is the reverse proxy for all the services.

## Prerequisites

- Server running docker
- Domain (e.g [Cloudflare](https://www.cloudflare.com/))
- DNS A-record pointing to your main server ip (e.g. 192.168.1.2)
- Wildcard CNAME record for your services, pointing to your A-record domain

## Initial Setup

Run 
```
docker network create traefik-network
./docker-compose.sh ACTIVE_SERVICES up -d
```

## Dashboard

The default dashboard is [homepage from benphelps](https://github.com/benphelps/homepage) (```./services/homepage```). Most services are already configured to appear on the dashboard when they are up and running.
