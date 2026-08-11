# 07 - WireGuard VPN

## Overview

WireGuard provides a secure VPN tunnel to access PocketNode services from outside your home network.

> ⚠️ **Note**: On older kernels (3.x), WireGuard runs in userspace mode which may have limited functionality. For full VPN from outside, consider Tailscale instead.

## Server Setup

Keys are generated automatically by `03-configure-services.sh`. Manual setup:

```bash
cd /etc/wireguard
wg genkey | tee server_private.key | wg pubkey > server_public.key
wg genkey | tee client_private.key | wg pubkey > client_public.key
chmod 600 *.key
```

### Server config (`/etc/wireguard/wg0.conf`):

```ini
[Interface]
PrivateKey = <server_private_key>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <client_public_key>
AllowedIPs = 10.0.0.2/32
```

### Start:
```bash
wg-quick up wg0
```

## Client Setup (Mac/iPhone)

1. Install **WireGuard** app from App Store
2. Create new tunnel with this config:

```ini
[Interface]
PrivateKey = <client_private_key>
Address = 10.0.0.2/24
DNS = 10.0.0.1

[Peer]
PublicKey = <server_public_key>
Endpoint = YOUR_PUBLIC_IP:51820
AllowedIPs = 10.0.0.0/24, 192.168.100.0/24
PersistentKeepalive = 25
```

> 💡 Replace `YOUR_PUBLIC_IP` with your home's public IP or dynamic DNS hostname.

## Get your keys

```bash
# On PocketNode via SSH:
echo "Client Private Key:"
cat /etc/wireguard/client_private.key
echo "Server Public Key:"
cat /etc/wireguard/server_public.key
```

## Port Forwarding

For external access, forward port **51820/UDP** on your router to `192.168.100.175`.

## Alternative: Tailscale

If WireGuard doesn't work on your kernel, use [Tailscale](https://tailscale.com):
```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

Tailscale works in userspace and is compatible with old kernels.

## Next Step

→ [08 - Dashboards](08-dashboards.md)

