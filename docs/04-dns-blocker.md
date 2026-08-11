# 04 - DNS Ad Blocker

## How It Works

PocketNode uses **dnsmasq** as a DNS server that:
1. Resolves normal domains via Google DNS (8.8.8.8)
2. Returns `0.0.0.0` for ad/tracker domains (blocking them)
3. Caches results for faster subsequent queries

This blocks ads on **ALL devices** on your network — phones, computers, smart TVs, etc.

## Configuration

The config file is at `/etc/dnsmasq.conf`:

```ini
server=8.8.8.8
server=8.8.4.4
listen-address=192.168.100.175,127.0.0.1
cache-size=10000
addn-hosts=/etc/pihole/gravity.list
no-resolv
user=root
bind-dynamic
```

## Block List

We use the [StevenBlack/hosts](https://github.com/StevenBlack/hosts) unified hosts file:
- **99,570+ domains** blocked
- Includes: ads, trackers, malware, fakenews sources
- Updated regularly by the community

### Update the block list:

```bash
curl -sSL https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -o /etc/pihole/gravity.list
killall dnsmasq && dnsmasq
```

### Add custom blocks:

```bash
echo "0.0.0.0 annoying-site.com" >> /etc/pihole/gravity.list
killall dnsmasq && dnsmasq
```

### Whitelist a domain:

Add to `/etc/dnsmasq.conf`:
```ini
server=/example.com/8.8.8.8
```

## Start the service

```bash
dnsmasq
```

## Test it works

From your Mac/PC:
```bash
# Normal resolution (should return an IP)
dig @192.168.100.175 google.com +short

# Blocked domain (should return 0.0.0.0 or empty)
dig @192.168.100.175 ads.doubleclick.net +short
```

## Make it network-wide

See [10 - Network DNS](10-network-dns.md) for router configuration.

## Why not Pi-hole?

Pi-hole v6 requires `fallocate()` on shared memory, which isn't supported on the Galaxy S3's kernel 3.4. dnsmasq provides the same core functionality (DNS-level blocking) without the web UI.

## Next Step

→ [05 - Samba](05-samba.md)

