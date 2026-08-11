# 09 - Auto-start on Boot

## Overview

PocketNode uses Android's `init.d` mechanism to start all services automatically when the phone boots.

## How it works

A script at `/system/etc/init.d/99pocketnode` runs at boot:
1. Waits 45 seconds (for WiFi to connect)
2. Mounts chroot filesystems (proc, sys, dev)
3. Sets DNS resolver
4. Starts all services inside the chroot

## Installation

```bash
./scripts/04-setup-autostart.sh
```

### Manual installation:

```bash
# Remount system as writable
adb shell "mount -o rw,remount /system"

# Push the boot script
adb push scripts/04-setup-autostart.sh /system/etc/init.d/99pocketnode

# Make executable
adb shell "chmod 755 /system/etc/init.d/99pocketnode"

# Remount as read-only
adb shell "mount -o ro,remount /system"
```

## Test

```bash
# Reboot the phone
adb reboot

# Wait ~60 seconds, then test SSH
ssh android@192.168.100.175
```

## Timing

| Event | Time |
|-------|------|
| Phone boots | 0s |
| Android loads | ~30s |
| WiFi connects | ~35s |
| Script starts | ~45s (sleep) |
| Services starting | ~50s |
| All services ready | **~60s** |

## Troubleshooting

### init.d not supported?

Some ROMs don't support init.d. Alternatives:

**Option A: Magisk service.d**
```bash
mkdir -p /data/adb/service.d
cp scripts/04-setup-autostart.sh /data/adb/service.d/99pocketnode.sh
chmod 755 /data/adb/service.d/99pocketnode.sh
```

**Option B: Use Tasker/MacroDroid app**
Set up automation: "On Boot" → Run Shell Command → `sh /system/etc/init.d/99pocketnode`

### Services didn't start?

Check manually:
```bash
adb shell "chroot /data/local/linux /bin/bash -c 'ss -tlnp'"
```

## Next Step

→ [10 - Network DNS](10-network-dns.md)

