# 10 - Network-wide DNS (Block ads for all devices)

## Overview

By pointing your router's DNS to PocketNode, **every device** on your network gets ad blocking automatically — no app installation needed.

## Option 1: Configure Router DNS (Recommended)

This makes ALL devices use PocketNode's DNS automatically.

### Steps:

1. Open your router's admin page (usually `http://192.168.1.1` or `http://192.168.100.1`)
2. Find **DHCP Settings** or **DNS Settings**
3. Change:
   - **Primary DNS**: `192.168.100.175` (PocketNode IP)
   - **Secondary DNS**: `8.8.8.8` (fallback if PocketNode is down)
4. Save and reboot router

### Common router pages:
| ISP/Router | URL |
|------------|-----|
| Telmex (HG8245H) | `http://192.168.1.254` |
| Totalplay | `http://192.168.100.1` |
| Izzi | `http://192.168.0.1` |
| TP-Link | `http://192.168.0.1` or `http://tplinkwifi.net` |
| Netgear | `http://192.168.1.1` or `http://routerlogin.net` |

## Option 2: Configure per device

### macOS
System Preferences → Network → WiFi → Advanced → DNS → Add `192.168.100.175`

### iPhone/iPad
Settings → WiFi → (i) next to your network → Configure DNS → Manual → Add `192.168.100.175`

### Windows
Settings → Network → WiFi → Hardware Properties → DNS → Edit → Manual → `192.168.100.175`

### Android
Settings → WiFi → Long press network → Modify → Advanced → DNS → `192.168.100.175`

## Option 3: Static IP for PocketNode

To prevent the phone's IP from changing, assign a static IP in your router:

1. Router admin → DHCP → Address Reservation
2. Add: MAC address of S3 → IP `192.168.100.175`

Or on the phone itself:
- Settings → WiFi → Long press → Modify → Advanced → Static IP → `192.168.100.175`

## Verify it works

After configuring DNS, test from any device:

```bash
# Should resolve normally
nslookup google.com

# Should be blocked (NXDOMAIN or 0.0.0.0)
nslookup ads.doubleclick.net
```

Or visit [https://ads-blocker.com/testing/](https://ads-blocker.com/testing/) — you should see most ads blocked.

## What gets blocked?

The StevenBlack list blocks:
- ✅ Advertising networks (Google Ads, Facebook Ads, etc.)
- ✅ Analytics/trackers (Google Analytics, Mixpanel, etc.)
- ✅ Malware domains
- ✅ Fake news domains (optional)
- ✅ Gambling sites (optional)

What still works:
- ✅ YouTube videos (ads are served from same domain)
- ✅ All normal websites
- ✅ App functionality
- ✅ Email, messaging, etc.

## Stats

After a day of use, you can check how many queries were blocked:
```bash
# On PocketNode:
cat /var/log/pihole/pihole.log | grep "0.0.0.0" | wc -l
```

---

🎉 **Congratulations!** Your PocketNode is now protecting your entire network from ads and trackers.

