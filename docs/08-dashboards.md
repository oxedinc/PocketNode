# 08 - Dashboards (Homer & Cockpit)

## Homer — Service Dashboard

Homer is a static dashboard page that shows links to all your PocketNode services in a clean UI.

### Access
`http://192.168.100.175:8080`

### Configuration

Edit `/var/www/homer/assets/config.yml` to customize services, colors, and layout.

See: `configs/homer/config.yml` in this repo.

### Web server

Homer is served by **lighttpd** on port 8080:
```bash
lighttpd -f /etc/lighttpd/lighttpd.conf
```

---

## Cockpit — Server Admin

Cockpit is a full web-based system administration tool. It lets you:
- Monitor CPU, RAM, disk, network in real-time
- Manage services (start/stop/restart)
- View system logs
- Manage storage
- Open a terminal in the browser

### Access
`http://192.168.100.175:9090`

**Login**: `android` / `android`

### Start

```bash
/usr/lib/cockpit/cockpit-ws --no-tls --port 9090 &
```

### Features available:
- 📊 System overview (CPU, RAM, disk)
- 📋 Logs viewer
- 🔧 Services management
- 💽 Storage management
- 🖥️ Web terminal
- 👥 User management

---

## Set as browser homepage

Add `http://192.168.100.175:8080` as your browser's homepage or new tab page to always have quick access to PocketNode services.

## Next Step

→ [09 - Auto-start](09-autostart.md)

