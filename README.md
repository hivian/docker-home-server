# Homeserver

A robust and extensible homeserver setup.

It is designed to be hosted and used only on your local network. 
Even though being only used on your local network it uses ```https``` via a wildcard certificate for everything.
You can still access from all around the world via a VPN e.g. Wireguard.
Traefik is the reverse proxy for all the services

## Initial Setup

### Prerequisites
- Server running docker
- Domain (e.g Cloudflare)
- DNS A-record pointing to your main server ip (e.g. 192.168.1.2)
- Wildcard CNAME record for your services, pointing to your A-record domain
