# 03 - Install Services

## Overview

All services run inside the Debian chroot. Install them with:

```bash
./scripts/02-install-services.sh
```

## Manual Installation

Enter the chroot first:
```bash
adb shell "chroot /data/local/linux /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash"
```

Then install each service:

```bash
# Update package list
apt-get update

# DNS ad blocker
apt-get install -y dnsmasq curl

# File sharing
apt-get install -y samba

# Torrent client
apt-get install -y transmission-daemon

# Web admin panel
apt-get install -y cockpit

# Dashboard web server
apt-get install -y lighttpd unzip

# Homer dashboard
mkdir -p /var/www/homer && cd /var/www/homer
curl -sSL https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip -o homer.zip
unzip -o homer.zip && rm homer.zip

# VPN
apt-get install -y wireguard-tools

# Useful utilities
apt-get install -y sudo curl git wget procps net-tools
```

## Verify Installation

```bash
which dnsmasq     # /usr/sbin/dnsmasq
which smbd        # /usr/sbin/smbd
which transmission-daemon  # /usr/bin/transmission-daemon
which lighttpd    # /usr/sbin/lighttpd
which wg          # /usr/bin/wg
```

## Disk Usage After Install

| Service | Size |
|---------|------|
| Base Debian | ~600 MB |
| Cockpit | ~200 MB |
| Samba | ~50 MB |
| Transmission | ~20 MB |
| dnsmasq | ~5 MB |
| Homer + lighttpd | ~30 MB |
| WireGuard tools | ~5 MB |
| **Total** | **~900 MB** |

## Next Step

→ [04 - DNS Blocker](04-dns-blocker.md)

