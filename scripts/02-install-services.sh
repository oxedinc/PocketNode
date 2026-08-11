#!/bin/bash
#===============================================================================
# PocketNode - 02-install-services.sh
# Install all services inside the Debian chroot
#===============================================================================

CHROOT="/data/local/linux"
CHR="adb shell chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c"

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  🚀 PocketNode — Installing Services     ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Update
echo "  📦 Updating packages..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c 'apt-get update -qq'"

# DNS Blocker
echo "  🛡️  Installing dnsmasq (DNS ad blocker)..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c 'apt-get install -y -qq dnsmasq curl'"

# Samba
echo "  📁 Installing Samba (file sharing)..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c 'apt-get install -y -qq samba'"

# Transmission
echo "  ⬇️  Installing Transmission (torrents)..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c 'apt-get install -y -qq transmission-daemon'"

# Cockpit
echo "  ⚙️  Installing Cockpit (web admin)..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c 'apt-get install -y -qq cockpit'"

# Homer + lighttpd
echo "  🌐 Installing Homer (dashboard)..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c '
apt-get install -y -qq lighttpd unzip
mkdir -p /var/www/homer
cd /var/www/homer
curl -sSL https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip -o homer.zip
unzip -o homer.zip > /dev/null 2>&1
rm homer.zip
'"

# WireGuard
echo "  🔐 Installing WireGuard..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin DEBIAN_FRONTEND=noninteractive /bin/bash -c 'apt-get install -y -qq wireguard-tools'"

echo ""
echo "  ✅ All services installed!"
echo "  Next: ./03-configure-services.sh"
echo ""

