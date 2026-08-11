# 02 - Install Debian

## Overview

PocketNode runs Debian 11 (Bullseye) inside a **chroot** on Android. This means:
- Debian runs alongside Android (not replacing it)
- The phone still works as a phone
- Both systems share the same kernel
- No virtualization overhead

## Automatic Installation

```bash
./scripts/01-install-debian.sh
```

This script handles everything automatically. If you prefer manual setup, read below.

## Manual Installation

### Step 1: Get root access via ADB

```bash
adb root
sleep 2
adb shell id
# Confirm: uid=0(root)
```

### Step 2: Install Linux Deploy + BusyBox

```bash
# Download and install
adb install linuxdeploy-2.6.0-259.apk
adb install busybox-v1_34_1-52.apk
```

Open BusyBox on the phone → tap "Install".

### Step 3: Configure Linux Deploy

```bash
# Set installation path
adb shell "sed -i 's|TARGET_PATH=.*|TARGET_PATH=\"/data/local/linux\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf"
adb shell "sed -i 's|CHROOT_DIR=.*|CHROOT_DIR=\"/data/local/linux\"|' /data/data/ru.meefik.linuxdeploy/files/cli.conf"

# Set mirror and suite
adb shell "sed -i 's|SOURCE_PATH=.*|SOURCE_PATH=\"http://deb.debian.org/debian/\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf"
adb shell "sed -i 's|SUITE=.*|SUITE=\"bullseye\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf"

# Disable desktop (server only)
adb shell "sed -i 's|DESKTOP=.*|DESKTOP=\"none\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf"
adb shell "sed -i 's|GRAPHICS=.*|GRAPHICS=\"none\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf"
```

### Step 4: Run the deployment

```bash
adb shell "mkdir -p /data/local/linux && \
  export ENV_DIR=/data/data/ru.meefik.linuxdeploy/files && \
  export PATH=\$ENV_DIR/bin:\$PATH && \
  sh \$ENV_DIR/cli.sh deploy"
```

This downloads and installs Debian. Takes 5-15 minutes.

### Step 5: Mount filesystems

```bash
adb shell "mount -o bind /proc /data/local/linux/proc"
adb shell "mount -o bind /sys /data/local/linux/sys"
adb shell "mount -o bind /dev /data/local/linux/dev"
adb shell "mount -t devpts devpts /data/local/linux/dev/pts"
adb shell "echo 'nameserver 8.8.8.8' > /data/local/linux/etc/resolv.conf"
```

### Step 6: Create user and setup SSH

```bash
adb shell "chroot /data/local/linux /bin/bash -c '
useradd -m -s /bin/bash android
echo android:android | chpasswd
apt-get install -y sudo openssh-server
echo \"android ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/android
chmod 440 /etc/sudoers.d/android
mkdir -p /run/sshd && chmod 755 /run/sshd
ssh-keygen -A
/usr/sbin/sshd
'"
```

### Step 7: Verify

```bash
# Get phone IP
IP=$(adb shell "ip addr show wlan0 | grep 'inet '" | awk '{print $2}' | cut -d/ -f1)

# Test SSH
ssh android@$IP
# Password: android
```

## Entering the chroot from the phone

Open a terminal app on the phone:
```bash
su
chroot /data/local/linux /bin/bash
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "debootstrap failed" | Check internet: `adb shell ping 8.8.8.8` |
| "No space left" | Need 4GB+ free on /data |
| Mirror timeout | Try `http://ftp.us.debian.org/debian/` |
| Permission denied | Make sure `adb root` works |

## Next Step

→ [03 - Install Services](03-install-services.md)

