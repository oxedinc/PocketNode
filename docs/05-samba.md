# 05 - Samba (File Sharing)

## Overview

Samba allows you to share folders from PocketNode accessible by Mac, Windows, Linux, and iOS devices.

## Configuration

`/etc/samba/smb.conf`:
```ini
[global]
workgroup = WORKGROUP
server string = PocketNode
security = user
map to guest = Bad User
dns proxy = no

[shared]
path = /shared
browsable = yes
writable = yes
guest ok = yes
create mask = 0777
directory mask = 0777
public = yes
```

## Setup

```bash
# Create shared directory
mkdir -p /shared
chmod 777 /shared

# Set Samba password for user
echo -e "android\nandroid" | smbpasswd -a android -s

# Start services
smbd
nmbd
```

## Access from devices

### macOS
- **Finder** → `Cmd + K` → `smb://192.168.100.175/shared`
- Or: Finder sidebar → Network → PocketNode

### Windows
- File Explorer → address bar: `\\192.168.100.175\shared`

### iOS (Files app)
- Files → `...` menu → Connect to Server → `smb://192.168.100.175/shared`

### Linux
```bash
# Mount temporarily
mount -t cifs //192.168.100.175/shared /mnt/pocketnode -o guest

# Or use file manager: smb://192.168.100.175/shared
```

## Add more shares

Edit `/etc/samba/smb.conf` and add:
```ini
[downloads]
path = /var/lib/transmission-daemon/downloads
browsable = yes
writable = no
guest ok = yes
```

Restart: `killall smbd && smbd`

## Next Step

→ [06 - Transmission](06-transmission.md)

