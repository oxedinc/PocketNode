#!/bin/bash
#===============================================================================
# PocketNode - 01-install-debian.sh
# Install Debian 11 (Bullseye) in a chroot on any rooted Android device
#===============================================================================

set -e

CHROOT="/data/local/linux"
MIRROR="http://deb.debian.org/debian/"
SUITE="bullseye"
ARCH="armhf"

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  🚀 PocketNode — Debian Installation     ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Check ADB
DEVICE=$(adb devices 2>/dev/null | grep -w "device" | head -1 | awk '{print $1}')
if [ -z "$DEVICE" ]; then
    echo "  ❌ No device found. Connect phone via USB and enable USB debugging."
    exit 1
fi
echo "  📱 Device: $DEVICE"

# Get root
echo "  🔓 Requesting root access..."
adb root 2>/dev/null
sleep 2

# Verify root
ROOT_CHECK=$(adb shell "id" 2>/dev/null | grep "uid=0")
if [ -z "$ROOT_CHECK" ]; then
    echo "  ❌ Could not get root. Make sure your phone is rooted."
    exit 1
fi
echo "  ✅ Root access confirmed"

# Check space
AVAIL=$(adb shell "df /data | tail -1 | awk '{print \$4}'" 2>/dev/null)
echo "  💽 Available space: ${AVAIL}KB"

# Install BusyBox + Linux Deploy if needed
echo "  📦 Checking dependencies..."
adb shell "pm list packages | grep ru.meefik.linuxdeploy" > /dev/null 2>&1 || {
    echo "  ⚠️  Linux Deploy not installed."
    echo "     Install from: https://github.com/meefik/linuxdeploy/releases"
    echo "     Then re-run this script."
    exit 1
}

# Configure Linux Deploy for headless Debian
echo "  ⚙️  Configuring installation..."
adb shell "
sed -i 's|TARGET_PATH=.*|TARGET_PATH=\"$CHROOT\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
sed -i 's|CHROOT_DIR=.*|CHROOT_DIR=\"$CHROOT\"|' /data/data/ru.meefik.linuxdeploy/files/cli.conf
sed -i 's|SOURCE_PATH=.*|SOURCE_PATH=\"$MIRROR\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
sed -i 's|SUITE=.*|SUITE=\"$SUITE\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
sed -i 's|ARCH=.*|ARCH=\"$ARCH\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
sed -i 's|DESKTOP=.*|DESKTOP=\"none\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
sed -i 's|GRAPHICS=.*|GRAPHICS=\"none\"|' /data/data/ru.meefik.linuxdeploy/files/config/linux.conf
"

# Deploy
echo "  🚀 Installing Debian $SUITE..."
echo "     This takes 5-15 minutes. Please wait..."
echo ""
adb shell "mkdir -p $CHROOT && export ENV_DIR=/data/data/ru.meefik.linuxdeploy/files && export PATH=\$ENV_DIR/bin:\$PATH && sh \$ENV_DIR/cli.sh deploy" 2>&1 | while read line; do
    echo "     $line"
done

# Mount filesystems
echo ""
echo "  🔗 Mounting filesystems..."
adb shell "
mount -o bind /proc $CHROOT/proc 2>/dev/null
mount -o bind /sys $CHROOT/sys 2>/dev/null
mount -o bind /dev $CHROOT/dev 2>/dev/null
mount -t devpts devpts $CHROOT/dev/pts 2>/dev/null
echo 'nameserver 8.8.8.8' > $CHROOT/etc/resolv.conf
"

# Setup user
echo "  👤 Creating user 'android'..."
adb shell "chroot $CHROOT /bin/bash -c '
useradd -m -s /bin/bash android 2>/dev/null
echo \"android:android\" | chpasswd
apt-get install -y sudo > /dev/null 2>&1
echo \"android ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/android
chmod 440 /etc/sudoers.d/android
'"

# Setup SSH
echo "  🔑 Setting up SSH..."
adb shell "chroot $CHROOT /bin/bash -c '
apt-get install -y openssh-server > /dev/null 2>&1
mkdir -p /run/sshd
chmod 755 /run/sshd
ssh-keygen -A 2>/dev/null
sed -i \"s/#PasswordAuthentication.*/PasswordAuthentication yes/\" /etc/ssh/sshd_config
/usr/sbin/sshd
'"

# Get IP
IP=$(adb shell "ip addr show wlan0 | grep 'inet ' | awk '{print \$2}' | cut -d/ -f1" 2>/dev/null | tr -d '\r')

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  ✅ PocketNode Debian installed!          ║"
echo "  ║                                           ║"
echo "  ║  SSH: ssh android@$IP       ║"
echo "  ║  Pass: android                            ║"
echo "  ║                                           ║"
echo "  ║  Next: ./02-install-services.sh           ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

