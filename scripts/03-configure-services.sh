#!/bin/bash
#===============================================================================
# PocketNode - 03-configure-services.sh
# Push configs and configure all services
#===============================================================================

CHROOT="/data/local/linux"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_DIR="$SCRIPT_DIR/../configs"

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  🚀 PocketNode — Configuring Services    ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Get phone IP
IP=$(adb shell "ip addr show wlan0 | grep 'inet ' | awk '{print \$2}' | cut -d/ -f1" 2>/dev/null | tr -d '\r')
echo "  📱 Phone IP: $IP"
echo ""

# DNS Blocker
echo "  🛡️  Configuring DNS blocker..."
adb push "$CONF_DIR/dns-blocker/dnsmasq.conf" $CHROOT/etc/dnsmasq.conf > /dev/null
adb shell "chroot $CHROOT /bin/bash -c '
mkdir -p /etc/pihole /var/log/pihole
curl -sSL https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o /etc/pihole/gravity.list
'"
BLOCKED=$(adb shell "wc -l $CHROOT/etc/pihole/gravity.list" | awk '{print $1}')
echo "  ✅ $BLOCKED domains will be blocked"

# Samba
echo "  📁 Configuring Samba..."
adb push "$CONF_DIR/samba/smb.conf" $CHROOT/etc/samba/smb.conf > /dev/null
adb shell "chroot $CHROOT /bin/bash -c '
mkdir -p /shared && chmod 777 /shared
echo -e \"android\nandroid\" | smbpasswd -a android -s 2>/dev/null
'"
echo "  ✅ Share: smb://$IP/shared"

# Transmission
echo "  ⬇️  Configuring Transmission..."
adb shell "chroot $CHROOT /bin/bash -c '
mkdir -p /var/lib/transmission-daemon/{downloads,incomplete}
chown -R debian-transmission:debian-transmission /var/lib/transmission-daemon
'"
echo "  ✅ Web UI: http://$IP:9091"

# Homer
echo "  🌐 Configuring Homer dashboard..."
adb push "$CONF_DIR/homer/config.yml" $CHROOT/var/www/homer/assets/config.yml > /dev/null
adb push "$CONF_DIR/homer/lighttpd.conf" $CHROOT/etc/lighttpd/lighttpd.conf > /dev/null
echo "  ✅ Dashboard: http://$IP:8080"

# WireGuard
echo "  🔐 Configuring WireGuard VPN..."
adb shell "chroot $CHROOT /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c '
mkdir -p /etc/wireguard && cd /etc/wireguard
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee client_private.key | wg pubkey > client_public.key
chmod 600 *.key
SERVER_PRIV=\$(cat server_private.key)
CLIENT_PUB=\$(cat client_public.key)
cat > wg0.conf << EOF
[Interface]
PrivateKey = \$SERVER_PRIV
Address = 10.0.0.1/24
ListenPort = 51820
[Peer]
PublicKey = \$CLIENT_PUB
AllowedIPs = 10.0.0.2/32
EOF
chmod 600 wg0.conf
'"

# Print client config
echo ""
echo "  📋 WireGuard client config (save this!):"
echo "  ─────────────────────────────────────────"
adb shell "chroot $CHROOT /bin/bash -c '
echo \"[Interface]\"
echo \"PrivateKey = \$(cat /etc/wireguard/client_private.key)\"
echo \"Address = 10.0.0.2/24\"
echo \"DNS = 10.0.0.1\"
echo \"\"
echo \"[Peer]\"
echo \"PublicKey = \$(cat /etc/wireguard/server_public.key)\"
echo \"Endpoint = '$IP':51820\"
echo \"AllowedIPs = 10.0.0.0/24, 192.168.100.0/24\"
echo \"PersistentKeepalive = 25\"
'" 2>/dev/null
echo "  ─────────────────────────────────────────"

echo ""
echo "  ✅ All services configured!"
echo "  Next: ./04-setup-autostart.sh"
echo ""

