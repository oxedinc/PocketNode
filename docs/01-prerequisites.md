# 01 - Prerequisites

## Hardware Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Phone | Any rooted Android 5+ | Samsung Galaxy S3 or newer |
| RAM | 1 GB | 2 GB |
| Storage | 4 GB free | 8 GB+ free |
| WiFi | 802.11 b/g/n | 802.11 n/ac |
| USB Cable | Micro USB / USB-C | For initial setup |

## Software Requirements

### On the phone:
- **Custom ROM** with root access (recommended: LineageOS, Resurrection Remix)
- **Root** via Magisk or built-in SuperUser
- **USB Debugging** enabled (Settings → Developer Options → USB Debugging)
- **Linux Deploy** app installed ([GitHub releases](https://github.com/meefik/linuxdeploy/releases))
- **BusyBox** app installed ([GitHub releases](https://github.com/meefik/busybox/releases))

### On your computer:
- **ADB** (Android Debug Bridge) installed
  - macOS: `brew install android-platform-tools`
  - Linux: `sudo apt install adb`
  - Windows: [Download SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools)
- **SSH client** (built-in on macOS/Linux, PuTTY on Windows)

## Tested Devices

| Device | Android | ROM | Status |
|--------|---------|-----|--------|
| Samsung Galaxy S3 (SPH-L710) | 7.1.2 | Resurrection Remix N v5.8.3 | ✅ |

## Getting Root Access

### Option A: ROM with built-in root
Many custom ROMs (Resurrection Remix, LineageOS with extras) include root. Check:
```bash
adb shell su -c id
# Should show: uid=0(root)
```

### Option B: Magisk
1. Download [Magisk](https://github.com/topjohnwu/Magisk/releases)
2. Flash via custom recovery (TWRP)
3. Open Magisk Manager → verify root

### Option C: adbd insecure (for older ROMs)
Some ROMs allow `adb root` directly if the build is `userdebug` or `eng`.

## Verify Everything Works

```bash
# Check device connected
adb devices
# Should show: <serial>  device

# Check root
adb root
adb shell id
# Should show: uid=0(root)

# Check available space
adb shell df -h /data
# Need at least 4GB free

# Check internet on phone
adb shell ping -c 3 8.8.8.8
# Should show responses
```

## Next Step

→ [02 - Install Debian](02-install-debian.md)

