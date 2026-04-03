# TahoeOS Architecture

## System Stack

```
┌──────────────────────────────────────────────────────────────┐
│                     USER APPLICATIONS                         │
│  Finder │ Terminal │ TextEdit │ Firefox │ Calculator │ Preview│
├──────────────────────────────────────────────────────────────┤
│                    TAHOEOS CUSTOM APPS                        │
│  Control Center │ App Store │ Backup │ Spotlight │ Installer  │
├──────────────────────────────────────────────────────────────┤
│                    GNOME DESKTOP (48)                          │
│  GNOME Shell │ Mutter │ GDM3 │ Nautilus │ GTK4/libadwaita    │
├──────────────────────────────────────────────────────────────┤
│                    VISUAL THEME LAYER                          │
│  Liquid Glass GTK │ Shell Theme │ Icons │ Cursor │ Fonts      │
├──────────────────────────────────────────────────────────────┤
│                    SYSTEM SERVICES                            │
│  GPU Manager │ Wine Integration │ Update Manager │ Backup     │
│  AppArmor │ UFW │ fprintd │ CUPS │ PipeWire │ GSConnect     │
├──────────────────────────────────────────────────────────────┤
│                    GAMING STACK                                │
│  Proton-GE │ DXVK │ vkd3d │ Gamescope │ MangoHud │ Gamemode  │
│  Lutris │ Heroic │ Steam │ vkBasalt │ GOverlay │ Winetricks  │
├──────────────────────────────────────────────────────────────┤
│                    DISPLAY & GRAPHICS                         │
│  Wayland │ XWayland │ Mesa │ Vulkan │ OpenGL                  │
├──────────────────────────────────────────────────────────────┤
│                    KERNEL (Fedora 6.x)                       │
│  Optimized │ BBR2 TCP │ zram │ Secure Boot │ Official updates│
├──────────────────────────────────────────────────────────────┤
│           BASE SYSTEM (Fedora 42)                            │
│  systemd │ dbus │ NetworkManager │ dnf │ Btrfs │ GRUB2       │
└──────────────────────────────────────────────────────────────┘
```

## Btrfs Subvolume Layout

```
/dev/sda1  EFI     512MB   vfat       → /boot/efi
/dev/sda2  Boot    1GB     ext4       → /boot
/dev/sda3  Root    rest    btrfs      → subvolumes below

Subvolumes:
  @         → /                 (root, snapshots)
  @home     → /home             (user data, snapshots)
  @snapshots→ /.snapshots       (snapshot storage)
  @cache    → /var/cache        (no snapshots)
  @log      → /var/log          (no snapshots)
  @tmp      → /tmp              (no snapshots)
  @swap     → swap file         (zram primary)
```

## Package Sources

| Source | Format | Use |
|--------|--------|-----|
| Fedora 42 repos | .rpm | Base system + ALL gaming packages |
| TahoeOS COPR/DNF repo | .rpm | Custom packages |
| Flathub | Flatpak | Applications |
| TahoeOS curated | Flatpak | Recommended apps |
| RPM Fusion | .rpm | NVIDIA drivers, multimedia codecs |

## Network Architecture

```
User System                          TahoeOS Servers
┌──────────────┐                    ┌──────────────────┐
│ DNF client   │──HTTPS────────────→│ copr.tahoeos.com │
│ (dnf/rpm)    │                    │ (COPR+nginx)     │
└──────────────┘                    └──────────────────┘
┌──────────────┐                    ┌──────────────────┐
│ Update daemon│──HTTPS────────────→│ update server    │
│ (polls repo) │                    │ (version meta)   │
└──────────────┘                    └──────────────────┘
┌──────────────┐                    ┌──────────────────┐
│ Flatpak      │──HTTPS────────────→│ flathub.org      │
│ client       │                    │ (Flatpak repo)   │
└──────────────┘                    └──────────────────┘
```

## Boot Sequence

```
UEFI/BIOS
  → GRUB2 (Liquid Glass theme)
    → Plymouth (animated splash)
      → GDM3 (Liquid Glass login)
        → GNOME Shell (Liquid Glass desktop)
          → User session starts
            → Autostart apps (dock, spotlight daemon, update daemon)
```

## Security Layers

```
┌─────────────────────────────────────┐
│ Application Layer                    │
│  AppArmor profiles per app          │
├─────────────────────────────────────┤
│ Network Layer                        │
│  UFW firewall (block incoming)      │
├─────────────────────────────────────┤
│ Authentication Layer                 │
│  PAM + fprintd + polkit             │
├─────────────────────────────────────┤
│ Storage Layer                        │
│  LUKS2 encryption + TPM             │
├─────────────────────────────────────┤
│ Boot Layer                           │
│  Secure Boot (signed shim)          │
├─────────────────────────────────────┤
│ Kernel Layer                         │
│  Kernel hardening + Liquorix patches│
└─────────────────────────────────────┘
```

## Update Flow

```
TahoeOS APT Repo (VPS)
  ├── stable/     (tested, production-ready)
  └── beta/       (latest, may have bugs)

User System:
  tahoe-update-daemon (systemd service)
    → Polls repo every 6 hours
    → Compares installed vs available versions
    → Sends D-Bus signal to Control Center
    → Shows "Update Available" in Settings
    → User clicks "Update Now"
    → Downloads + installs packages
    → Creates Btrfs snapshot before update
    → Prompts restart if kernel updated
```
