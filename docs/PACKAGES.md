# TahoeOS Custom Packages

**30 custom packages that make TahoeOS unique.**

---

## Package List

| # | Package | Description | Dependencies |
|---|---------|-------------|--------------|
| P01 | tahoe-gtk-theme | Liquid Glass GTK3/4 theme | sassc |
| P02 | tahoe-shell-theme | GNOME Shell Liquid Glass theme | gnome-shell |
| P03 | tahoe-icon-theme | Full custom icon pack (200+) | — |
| P04 | tahoe-cursor-theme | macOS-style cursor | — |
| P05 | tahoe-fonts | Inter + JetBrains Mono | — |
| P06 | tahoe-wallpapers | Custom Liquid Glass wallpapers | — |
| P07 | tahoe-grub-theme | GRUB2 Liquid Glass theme | grub2-efi |
| P08 | tahoe-plymouth-theme | Animated boot splash | plymouth |
| P09 | tahoe-gdm-theme | Login screen theme | gdm |
| P10 | tahoe-control-center | macOS-style Settings app | python3-gi, gtk4, libadwaita |
| P11 | tahoe-app-store | Unified app store | python3-gi, flatpak |
| P12 | tahoe-gpu-manager | GPU auto-detect + driver install | pciutils |
| P13 | tahoe-wine-integration | .exe/.msi handler | wine, winetricks |
| P14 | tahoe-gaming | Gaming stack installer | wine, dxvk, vkd3d-proton, gamescope |
| P15 | tahoe-update-manager | OTA update system | dnf, systemd |
| P16 | tahoe-notifications | macOS notification style | gnome-shell |
| P17 | tahoe-spotlight | Spotlight launcher config | ulauncher |
| P18 | tahoe-dock | macOS-style dock config | plank |
| P19 | tahoe-terminal | Terminal theme + config | gnome-terminal |
| P20 | tahoe-branding | ALL system branding | — |
| P21 | tahoe-backup | Time Machine clone | btrfs-progs, snapper |
| P22 | tahoe-security | Security profiles | apparmor, ufw |
| P23 | tahoe-window-manager | Mission Control + extensions | gnome-shell |
| P24 | tahoe-lock-screen | macOS lock screen | gnome-shell |
| P25 | tahoe-kernel-config | Kernel + sysctl tuning | — |
| P26 | tahoe-browser | Themed Firefox | firefox |
| P27 | tahoe-app-mapping | Renamed desktop entries | — |
| P28 | tahoe-shell-config | macOS top bar + zsh | gnome-shell, zsh |
| P29 | tahoe-help | Built-in help app | — |
| P30 | tahoe-installer | macOS setup assistant (QML) | qt6, qml |

---

## Package Details

### P01: tahoe-gtk-theme
```
Type: Theme (GTK3 + GTK4)
Base: Fork vinceliuice/MacTahoe-gtk-theme (MIT)
Build: sassc, inkscape
Install: /usr/share/themes/TahoeOS/
Files:
  - gtk-3.0/gtk.css
  - gtk-3.0/gtk-dark.css
  - gtk-4.0/gtk.css
  - gtk-4.0/gtk-dark.css
  - assets/ (icons, images)
Features:
  - Liquid Glass transparency
  - Rounded corners (12px)
  - Light + Dark + Auto modes
  - macOS accent colors
```

### P02: tahoe-shell-theme
```
Type: Theme (GNOME Shell)
Base: Fork kayozxo/GNOME-macOS-Tahoe (GPL-3.0)
Install: /usr/share/gnome-shell/theme/TahoeOS/
Files:
  - gnome-shell.css
  - gnome-shell-high-contrast.css
  - assets/
Features:
  - Transparent top bar
  - macOS overview/dash
  - Floating notifications
  - Volume/brightness OSD
```

### P03: tahoe-icon-theme
```
Type: Icon theme
Base: Fork vinceliuice/MacTahoe-icon-theme (GPL-3.0)
Install: /usr/share/icons/TahoeOS/
Size: ~200MB
Coverage:
  - 200+ application icons
  - Folder icons (all colors)
  - Device icons
  - Action icons
  - Status icons
  - Category icons
Custom icons (macOS 1:1):
  - firefox → Safari-style
  - steam → macOS Steam
  - terminal → macOS Terminal
  - nautilus → Finder
  - text-editor → TextEdit
  - calculator → macOS Calculator
  - settings → macOS System Settings
  - evince → Preview
  - (200+ more)
```

### P10: tahoe-control-center
```
Type: Application (Python + GTK4/libadwaita)
Install: /usr/bin/tahoe-control-center
Dependencies: python3-gi, gir1.2-gtk-4.0, gir1.2-adw-1
Panels:
  - Wi-Fi (NetworkManager D-Bus)
  - Bluetooth (BlueZ D-Bus)
  - Displays (resolution, scaling, night light, HDR)
  - Sound (PipeWire)
  - Wallpaper (file picker + dynamic)
  - Appearance (theme, accent, dock, icons)
  - GPU Drivers (lspci detect + apt install)
  - Software Update (APT repo poll)
  - Privacy (lock screen, sharing, firewall)
  - Users (account management)
  - Apps (default apps, startup apps)
  - Keyboard (layout, shortcuts)
  - Mouse & Trackpad (sensitivity, gestures)
  - About (system info, macOS-style panel)
  - Startup Disk (boot disk selection)
  - Energy (sleep, battery, power profiles)
  - Network (firewall, VPN)
```

### P21: tahoe-backup
```
Type: Daemon + Application
Install: /usr/bin/tahoe-backup
Dependencies: btrfs-progs, snapper, grub-btrfs
Services:
  - tahoe-backup.timer (hourly)
  - tahoe-backup.service
Features:
  - Btrfs snapshots
  - Timeline browser
  - File restore
  - System restore
  - Pre-update snapshots
  - GRUB snapshot boot entries
  - Retention: hourly(24h), daily(30d), weekly(12w), monthly(6m)
  - Destinations: local, external, network (SMB/NFS)
```

### P30: tahoe-installer
```
Type: Application (C++ + QML)
Install: /usr/bin/tahoe-installer
Dependencies: qt6-base, qt6-declarative, qt6-multimedia
Screens (9):
  1. Welcome (language grid)
  2. Region (map + keyboard)
  3. Wi-Fi (network list)
  4. Disk Selection (drive picker)
  5. Account (create user)
  6. Appearance (light/dark + accent)
  7. Privacy (telemetry toggles)
  8. Progress (animated install)
  9. Complete (welcome to TahoeOS)
Backend:
  - Partitioning (parted)
  - debootstrap
  - User creation
  - Package installation
  - GRUB installation
  - Encryption setup (LUKS2)
```
