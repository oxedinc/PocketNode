<div align="center">

# 🚀 PocketNode
<img width="2048" height="768" alt="E6D34CEE-8F56-4A69-9673-FBFAABE2C5F2" src="https://github.com/user-attachments/assets/7ccf7887-b06f-4204-97b9-f4546c0ca2a8" />

### Turn any old Android phone into a powerful Linux home server

<p>
  <img src="https://img.shields.io/badge/platform-Android-green?logo=android" alt="Android">
  <img src="https://img.shields.io/badge/OS-Debian_11-red?logo=debian" alt="Debian">
  <img src="https://img.shields.io/badge/arch-ARMv7-blue" alt="ARM">
  <img src="https://img.shields.io/badge/power-2W-yellow" alt="2W">
  <img src="https://img.shields.io/badge/cost-$0-brightgreen" alt="Free">
  <img src="https://img.shields.io/github/license/YOUR_USER/PocketNode" alt="License">
</p>

<p>
  <strong>DNS ad blocking • File sharing • Torrents • VPN • Web dashboard</strong><br>
  All running 24/7 on a phone that fits in your pocket.
</p>

---

[Features](#-features) • [Services](#-services) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Docs](#-documentation)

</div>

---

## 💡 What is PocketNode?

**PocketNode** transforms old Android smartphones (like a Samsung Galaxy S3) into fully functional Linux home servers. Instead of throwing away outdated phones, give them a second life as always-on, silent, ultra-low-power servers that provide real utility to your home network.

> 📱 → 🖥️ Your old phone becomes your new server.

### Why PocketNode?

| | Traditional Server | PocketNode |
|---|---|---|
| 💰 Cost | $100-500+ | $0 (reuse old phone) |
| ⚡ Power | 50-100W | **~2W** |
| 🔇 Noise | Fans spinning | Silent |
| 📦 Size | Tower/NUC | Fits in pocket |
| 🌱 Eco | New hardware | ♻️ Recycled |
| 🔋 UPS | Needed separately | Built-in battery! |

---

## ✨ Features

- 🛡️ **Network-wide ad blocking** — Block 99,570+ ad/tracker domains for ALL devices
- 📁 **File sharing** — Access shared folders from Mac, Windows, Linux, iOS
- ⬇️ **Torrent downloads** — Web-based torrent client with remote access
- 🔐 **VPN server** — Secure access to your home network from anywhere
- 🖥️ **Web dashboard** — Beautiful Homer page with all your services
- ⚙️ **Server admin** — Cockpit web panel for system management
- 🔑 **SSH access** — Full terminal access over the network
- 🔄 **Auto-start** — Everything starts automatically on phone boot
- 📱 **Phone terminal** — Manage directly from the phone's screen

---

## 🧩 Services

| Service | Port | Access | What it does |
|---------|------|--------|--------------|
| 🌐 **Homer** | 8080 | `http://<IP>:8080` | Dashboard with links to everything |
| ⚙️ **Cockpit** | 9090 | `http://<IP>:9090` | Web-based server administration |
| ⬇️ **Transmission** | 9091 | `http://<IP>:9091` | Download torrents via web UI |
| 🔑 **SSH** | 22 | `ssh android@<IP>` | Remote terminal access |
| 🛡️ **DNS Blocker** | 53 | Set as router DNS | Blocks ads network-wide |
| 📁 **Samba** | 445 | `smb://<IP>/shared` | File sharing |
| 🔐 **WireGuard** | 51820 | WireGuard app | VPN tunnel |

---

## 🚀 Quick Start

### Requirements

- Any **rooted Android phone** (tested on Galaxy S3, but works on others)
- Custom ROM recommended (LineageOS, Resurrection Remix, etc.)
- USB cable + computer with [ADB](https://developer.android.com/tools/adb) installed
- WiFi connection

### Installation

```bash
# Clone this repo
git clone https://github.com/YOUR_USER/PocketNode.git
cd PocketNode

# Connect phone via USB
adb devices

# Run installation scripts
chmod +x scripts/*.sh
./scripts/01-install-debian.sh
./scripts/02-install-services.sh
./scripts/03-configure-services.sh
./scripts/04-setup-autostart.sh
```

### First Access

```bash
# SSH into your PocketNode
ssh android@<PHONE_IP>
# Password: android

# Open the dashboard in your browser
open http://<PHONE_IP>:8080
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│              📱 PocketNode                       │
│           Android + Debian Chroot                │
│                                                  │
│  ┌────────────────────────────────────────────┐  │
│  │          Debian 11 (Bullseye)              │  │
│  │                                            │  │
│  │  ┌──────────┐  ┌───────────────────────┐  │  │
│  │  │ dnsmasq  │  │    Transmission       │  │  │
│  │  │  :53     │  │    :9091              │  │  │
│  │  └──────────┘  └───────────────────────┘  │  │
│  │  ┌──────────┐  ┌───────────────────────┐  │  │
│  │  │  Samba   │  │     Cockpit           │  │  │
│  │  │  :445    │  │     :9090             │  │  │
│  │  └──────────┘  └───────────────────────┘  │  │
│  │  ┌──────────┐  ┌───────────────────────┐  │  │
│  │  │  sshd    │  │  Homer (lighttpd)     │  │  │
│  │  │  :22     │  │     :8080             │  │  │
│  │  └──────────┘  └───────────────────────┘  │  │
│  │  ┌──────────────────────────────────────┐ │  │
│  │  │      WireGuard VPN :51820            │ │  │
│  │  └──────────────────────────────────────┘ │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  🔄 init.d/99linux → auto-starts everything     │
└──────────────────────────────────────────────────┘
              │ WiFi: 192.168.x.x
              ▼
        🏠 Home Network
              │
        ┌─────┴─────┐
        │   Router   │ ← DNS pointed to PocketNode
        └─────┬─────┘
              │
     ┌────────┼────────┐
     │        │        │
    💻       📱      📺
   Mac    iPhone     TV     ← All ads blocked ✅
```

---

## 📊 Performance

| Metric | Value |
|--------|-------|
| RAM (all services running) | ~300 MB / 1,772 MB |
| Storage used | ~2.1 GB / 12 GB available |
| Boot → services ready | ~60 seconds |
| DNS response time | ~25 ms |
| Blocked domains | 99,570+ |
| Power consumption | ~2 Watts |
| Monthly electricity cost | ~$0.05 USD |

---

## 📖 Documentation

| Doc | Description |
|-----|-------------|
| [01 - Prerequisites](docs/01-prerequisites.md) | Hardware & software requirements |
| [02 - Install Debian](docs/02-install-debian.md) | Chroot setup guide |
| [03 - Install Services](docs/03-install-services.md) | Service installation |
| [04 - DNS Blocker](docs/04-dns-blocker.md) | Network-wide ad blocking |
| [05 - Samba](docs/05-samba.md) | File sharing setup |
| [06 - Transmission](docs/06-transmission.md) | Torrent client |
| [07 - WireGuard](docs/07-wireguard.md) | VPN server |
| [08 - Dashboards](docs/08-dashboards.md) | Homer & Cockpit |
| [09 - Auto-start](docs/09-autostart.md) | Boot automation |
| [10 - Network DNS](docs/10-network-dns.md) | Router configuration |

---

## 🗂️ Project Structure

```
PocketNode/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── 01-install-debian.sh
│   ├── 02-install-services.sh
│   ├── 03-configure-services.sh
│   └── 04-setup-autostart.sh
├── configs/
│   ├── dns-blocker/
│   │   └── dnsmasq.conf
│   ├── samba/
│   │   └── smb.conf
│   ├── transmission/
│   │   └── settings.json
│   ├── wireguard/
│   │   └── wg0.conf.example
│   ├── homer/
│   │   ├── config.yml
│   │   └── lighttpd.conf
│   └── cockpit/
│       └── cockpit.conf
└── docs/
    ├── 01-prerequisites.md
    └── ...
```

---

## 🤝 Compatible Devices

Tested and confirmed working:

| Device | Android | ROM | Status |
|--------|---------|-----|--------|
| Samsung Galaxy S3 (d2spr) | 7.1.2 | Resurrection Remix | ✅ Fully working |

Should work on any rooted Android with:
- ARM/ARM64 processor
- 1GB+ RAM
- 4GB+ internal storage
- WiFi connectivity

> 📋 **Tested yours?** Open a PR to add it to the list!

---

## 🛣️ Roadmap

- [ ] One-command installer script
- [ ] Support for ARM64 devices
- [ ] Tailscale integration
- [ ] Vaultwarden (password manager)
- [ ] Uptime Kuma (monitoring)
- [ ] Automated backup system
- [ ] Web-based initial setup wizard
- [ ] Docker support (for newer kernels)

---

## ⚠️ Limitations

- **Old kernels** (3.x) — Some modern software won't work (Pi-hole FTL v6, WireGuard kernel module)
- **WiFi speed** — Limited by phone's WiFi chip (~1-10 Mbps on older devices)
- **No hardware transcoding** — Not suitable for video streaming
- **ARM 32-bit** — Some software only supports ARM64/x86

---

## 🤝 Contributing

Contributions welcome! See our [contributing guide](CONTRIBUTING.md).

1. Fork this repo
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

**⭐ Star this repo if you think old phones deserve a second life!**

Made with ❤️ by recycling an old Galaxy S3 that refused to retire

[Report Bug](../../issues) • [Request Feature](../../issues) • [Discussions](../../discussions)

</div>

