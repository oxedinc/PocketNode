# 06 - Transmission (Torrents)

## Overview

Transmission is a lightweight torrent client with a web interface accessible from any browser.

## Access

- **Web UI**: `http://192.168.100.175:9091`
- **Downloads folder**: `/var/lib/transmission-daemon/downloads`

## Start

```bash
transmission-daemon --allowed "*" --port 9091
```

## Configuration

Settings are stored in `/var/lib/transmission-daemon/.config/transmission-daemon/settings.json` (created after first run).

Key settings:
```json
{
    "download-dir": "/var/lib/transmission-daemon/downloads",
    "incomplete-dir": "/var/lib/transmission-daemon/incomplete",
    "rpc-port": 9091,
    "rpc-whitelist-enabled": false,
    "rpc-authentication-required": false,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 100,
    "speed-limit-up-enabled": true,
    "peer-port": 51413
}
```

> ⚠️ Stop transmission before editing settings: `killall transmission-daemon`

## Access downloads via Samba

Add to `/etc/samba/smb.conf`:
```ini
[downloads]
path = /var/lib/transmission-daemon/downloads
browsable = yes
read only = yes
guest ok = yes
```

Then access from Mac: `smb://192.168.100.175/downloads`

## Remote apps

You can use these apps to control Transmission remotely:
- **iOS**: Transmission Remote (App Store)
- **macOS**: Transmission Remote GUI
- **Android**: Transdroid

All connect to: `http://192.168.100.175:9091`

## Next Step

→ [07 - WireGuard](07-wireguard.md)

