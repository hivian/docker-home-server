# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A self-hosted Docker home server setup using Traefik as a reverse proxy with automatic HTTPS via Let's Encrypt (Cloudflare DNS challenge). Services are organized into independent stacks, each in its own subdirectory.

## Common Commands

**One-time network setup (required before first run):**
```bash
docker network create traefik-network
```

**Start/stop service groups (uses root `.env` to resolve `ACTIVE_SERVICES`):**
```bash
./docker-compose.sh ACTIVE_SERVICES up -d
./docker-compose.sh ACTIVE_SERVICES down
```

**Operate on a single service stack directly:**
```bash
cd traefik && docker compose up -d
cd media-server && docker compose down
docker compose -f media-server/docker-compose.yml logs -f
```

**Restart specific service groups (uses `RESTART_SERVICES` from `.env`):**
```bash
./docker-compose.sh RESTART_SERVICES restart
```

**Test VPN/Gluetun connectivity:**
```bash
docker run --rm --network=container:gluetun alpine:3.18 sh -c "apk add wget && wget -qO- https://ipinfo.io"
```

**Fix Grafana volume permissions if needed:**
```bash
chown 472:root ./monitoring/data/.
```

## Architecture

### Network Model
All services share a single external Docker bridge network (`traefik-network`, subnet `172.18.0.0/16`). Traefik listens on this network and routes HTTPS traffic based on hostname. Services are registered with Traefik via Docker labels — no static config files needed.

Pihole and Unbound have fixed IPs on the subnet (`172.18.0.20` and `172.18.0.21`) for DNS chaining: Pi-hole forwards to Unbound for recursive resolution.

### Service Stacks
Each subdirectory is an independent stack:

| Directory | Services |
|-----------|----------|
| `traefik/` | Traefik reverse proxy + whoami |
| `media-server/` | Gluetun (VPN) + qBittorrent + Jackett + Jellyfin + Unmanic |
| `pihole/` | Pi-hole + Unbound |
| `monitoring/` | Prometheus + Grafana + cAdvisor + Node Exporter + Alertmanager |
| `homepage/` | Homepage dashboard |
| `nextcloud/` | Nextcloud |
| `portainer/` | Portainer |
| `homeassistant/` | Home Assistant |

### Environment Variable Layering
- Root `.env` defines global vars: `PUID`, `PGID`, `TZ`, `VOLUMES_ROOT_PATH`, `SERVER_DOMAIN`, `SERVER_IP`, `URL_SCHEME`, `ACTIVE_SERVICES`, `RESTART_SERVICES`
- Each stack's `.env` inherits globals and adds stack-specific vars (e.g., `VOLUME_PATH=${VOLUMES_ROOT_PATH}/media-server`, subdomain names, API keys)
- `.env.template` files are committed; `.env` files with real values are gitignored

### Traefik Integration Pattern
Services expose themselves to Traefik and Homepage exclusively via Docker labels:
```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.<name>.rule=Host(`${SUB_DOMAIN}.${SERVER_DOMAIN}`)
  - traefik.http.routers.<name>.entrypoints=websecure
  - traefik.http.services.<name>.loadbalancer.server.port=<port>
  - homepage.group=<Group>
  - homepage.name=<Name>
  - homepage.href=${URL_SCHEME}://${SUB_DOMAIN}.${SERVER_DOMAIN}
  - homepage.widget.type=<type>
  - homepage.widget.url=${URL_SCHEME}://${SUB_DOMAIN}.${SERVER_DOMAIN}
```

### VPN Routing
qBittorrent and Jackett route all traffic through the Gluetun container using `network_mode: service:gluetun`. Traefik routes to them via Gluetun's network (labels on the Gluetun container, not the apps). Since they share Gluetun's namespace, qBittorrent reaches Jackett at `http://localhost:9117`.

qBittorrent's Search tab is wired to Jackett with the official `jackett.py` search plugin (Search > Search plugins > Install new > Web link), configured via `/config/qBittorrent/nova3/engines/jackett.json` (`url` = `http://localhost:9117`, `api_key` = Jackett API key).

### gitignore Strategy
`.gitignore` uses an allowlist approach: ignores everything in subdirectories by default, then explicitly un-ignores `docker-compose.yml` and `.env.template`. This means new files added to stack directories (data, configs, secrets) are automatically excluded.
