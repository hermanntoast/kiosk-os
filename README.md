# Kiosk OS

Minimales Linux-Betriebssystem basierend auf Buildroot für Kiosk-Anwendungen.

## Features

- Chromium im Kiosk-Modus (Vollbild, keine UI-Elemente)
- URL per Kernelparameter konfigurierbar
- Automatischer Neustart bei Browser-Absturz
- X11-basiert (keine Desktop-Umgebung)
- ~400 MB ISO-Image
- GitHub Actions CI/CD für automatische Builds

## Fertige Images herunterladen

Die einfachste Methode: Lade ein fertiges ISO von den [GitHub Releases](../../releases) herunter.

Bei jedem Push auf `main` und bei Tags wird automatisch ein neues Image gebaut.

## Lokal Bauen

### Voraussetzungen

- Linux Host-System
- ca. 15 GB freier Speicherplatz für Build
- Build-Abhängigkeiten:

```bash
# Debian/Ubuntu
sudo apt-get install build-essential git libncurses5-dev bc flex bison \
    libssl-dev unzip rsync cpio wget file

# Arch Linux
sudo pacman -S base-devel git ncurses bc flex bison openssl unzip rsync cpio wget
```

## Bauen

```bash
# Repository klonen mit Submodul
git clone --recursive https://github.com/dein-user/kiosk-os.git
cd kiosk-os

# ODER nach dem Klonen:
git submodule update --init

# Konfiguration anwenden und bauen
make build

# Das dauert beim ersten Mal 1-2 Stunden (je nach System und Internetverbindung)
```

## Konfiguration anpassen

```bash
make menuconfig
make savedefconfig  # Änderungen speichern
```

## Ergebnis

Nach dem Build findest du das ISO hier:
```
buildroot/output/images/rootfs.iso9660
```

## USB-Stick erstellen

```bash
sudo dd if=buildroot/output/images/rootfs.iso9660 of=/dev/sdX bs=4M status=progress
sync
```

**Achtung:** Ersetze `/dev/sdX` mit deinem USB-Gerät (z.B. `/dev/sdb`).

## Booten

### Standard-URL (example.com)
Einfach booten - die Standard-URL ist `https://example.com`.

### Eigene URL
Beim Bootloader (SYSLINUX) die Kernel-Zeile editieren (Tab-Taste) und anpassen:

```
kiosk_url=https://deine-dashboard-url.de/display
```

### GRUB (falls installiert)
Die Kernel-Commandline anpassen und `kiosk_url=...` hinzufügen.

## Beispiel-URLs

```
kiosk_url=https://grafana.local:3000/d/dashboard
kiosk_url=https://home-assistant.local:8123/lovelace/0
kiosk_url=file:///var/www/index.html
```

## Debugging

Boot mit `init=/bin/sh` für eine Shell ohne X11:
```
kiosk_url=https://example.com init=/bin/sh
```

SSH ist aktiviert (Dropbear) - Standard-Login ist `root` ohne Passwort.

## Projektstruktur

```
kiosk-os/
├── buildroot/                    # Buildroot (Git-Submodul)
├── configs/
│   └── kiosk_x86_64_defconfig    # Buildroot-Konfiguration
├── board/
│   └── kiosk/
│       ├── rootfs_overlay/       # Overlay-Dateien fürs Rootfs
│       ├── isolinux.cfg          # Bootloader-Konfiguration
│       └── post-build.sh         # Post-Build Script
├── Config.in                     # BR2_EXTERNAL Config
├── external.mk                   # BR2_EXTERNAL Makefiles
├── external.desc                 # BR2_EXTERNAL Beschreibung
├── Makefile                      # Haupt-Makefile
└── README.md                     # Diese Datei
```

## CI/CD (GitHub Actions)

Der Build wird automatisch ausgeführt bei:
- Push auf `main` oder `master`
- Pull Requests
- Tags (erstellt automatisch ein Release)

### Manueller Build

Unter "Actions" → "Build Kiosk OS" → "Run workflow" kann ein Build manuell gestartet werden.

### Release erstellen

```bash
git tag v1.0.0
git push origin v1.0.0
```

Das erstellt automatisch ein GitHub Release mit dem ISO-Image.

## Lizenz

Die eigenen Dateien stehen unter MIT-Lizenz. Buildroot und enthaltene Pakete unterliegen ihren jeweiligen Lizenzen.
