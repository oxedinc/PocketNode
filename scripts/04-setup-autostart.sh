#!/bin/bash
#===============================================================================
# PocketNode - 04-setup-autostart.sh
# Install the boot script that starts all services automatically
#===============================================================================

CHROOT="/data/local/linux"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  🚀 PocketNode — Setting up Auto-start   ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Create the init.d boot script
cat > /tmp/99pocketnode << 'BOOTSCRIPT'
#!/system/bin/sh
# PocketNode - Auto-start all services on boot
sleep 45

CHROOT=/data/local/linux

# Mount filesystems
mountpoint -q $CHROOT/proc || mount -o bind /proc $CHROOT/proc
mountpoint -q $CHROOT/sys || mount -o bind /sys $CHROOT/sys
mountpoint -q $CHROOT/dev || mount -o bind /dev $CHROOT/dev
mount -t devpts devpts $CHROOT/dev/pts 2>/dev/null

# DNS for the chroot
echo "nameserver 8.8.8.8" > $CHROOT/etc/resolv.conf

# Fix directories
mkdir -p $CHROOT/run/sshd
chmod 755 $CHROOT/run/sshd

# Start all services
chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c '
/usr/sbin/sshd
sleep 2
dnsmasq
smbd
nmbd
transmission-daemon --allowed "*" --port 9091
lighttpd -f /etc/lighttpd/lighttpd.conf
/usr/lib/cockpit/cockpit-ws --no-tls --port 9090 &
wg-quick up wg0 2>/dev/null
'
BOOTSCRIPT

# Push to device
echo "  📤 Pushing boot script..."
adb shell "mount -o rw,remount /system" 2>/dev/null
adb push /tmp/99pocketnode /system/etc/init.d/99pocketnode > /dev/null
adb shell "chmod 755 /system/etc/init.d/99pocketnode"
adb shell "mount -o ro,remount /system" 2>/dev/null

echo "  ✅ Auto-start configured!"
echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  🎉 PocketNode setup complete!            ║"
echo "  ║                                           ║"
echo "  ║  All services will start automatically    ║"
echo "  ║  ~60 seconds after phone boots.           ║"
echo "  ║                                           ║"
echo "  ║  Reboot the phone to test:                ║"
echo "  ║  $ adb reboot                             ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Cleanup
rm -f /tmp/99pocketnode

