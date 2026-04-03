# TahoeOS VPS Build Guide

**Quick-start guide for building TahoeOS on a Fedora 42 VPS.**

---

## Prerequisites

- Fedora 42 VPS with 8GB+ RAM
- Root access
- ~50GB disk space

---

## Step 1: Clone Repository

```bash
dnf upgrade -y
dnf install -y git

cd /home
git clone https://github.com/YOUR_REPO/tahoeos.git
cd tahoeos
```

---

## Step 2: Install Build Dependencies

```bash
dnf install -y \
    lorax livecd-tools pykickstart anaconda \
    wget curl unzip \
    python3 python3-pip python3-gobject python3-devel \
    gtk4-devel libadwaita-devel webkit2gtk4.1 \
    sassc inkscape optipng ImageMagick \
    qt6-qtbase qt6-qtdeclarative qt6-qtquickcontrols2 \
    rpm-build rpmdevtools \
    zsh firewalld fail2ban snapper btrfs-progs \
    ulauncher wine steam lutris gamescope mangohud gamemode
```

---

## Step 3: Install All Packages

```bash
chmod +x install-all-packages.sh
sudo ./install-all-packages.sh
```

This installs all 33 TahoeOS packages:
- Theme packages (GTK, Shell, Icons, Cursors, GRUB, Plymouth, GDM)
- Custom apps (Control Center, Update Manager, Backup, Help)
- Gaming stack (Steam, Wine, Lutris, Gamescope)
- Configuration packages (Terminal, Browser, Dock, Security)

---

## Step 4: Build ISO

```bash
sudo livemedia-creator \
    --ks=build/kickstart/tahoeos.ks \
    --no-virt \
    --resultdir=./iso/output \
    --project=TahoeOS \
    --releasever=42 \
    --iso-only \
    --iso-name=TahoeOS-2026.1-x86_64.iso \
    --tmp=/var/tmp
```

---

## Package List

| # | Package | Type |
|---|---------|------|
| 01 | tahoe-gtk-theme | WhiteSur GTK theme |
| 02 | tahoe-shell-theme | GNOME Shell theme |
| 03 | tahoe-icon-theme | WhiteSur icons |
| 04 | tahoe-cursor-theme | macOS cursors |
| 05 | tahoe-fonts | Inter + JetBrains Mono |
| 06 | tahoe-wallpapers | Gradient wallpapers |
| 07 | tahoe-grub-theme | GRUB bootloader theme |
| 08 | tahoe-plymouth-theme | Boot splash |
| 09 | tahoe-gdm-theme | Login screen theme |
| 10 | tahoe-sound-theme | System sounds |
| 11 | tahoe-default-settings | dconf defaults |
| 12 | tahoe-branding | /etc/os-release |
| 13 | tahoe-control-center | System Settings app |
| 14 | tahoe-app-store | Unified app store |
| 15 | tahoe-gpu-manager | GPU driver installer |
| 16 | tahoe-wine-integration | .exe handler |
| 17 | tahoe-gaming | Gaming stack |
| 18 | tahoe-update-manager | Software Update app |
| 19 | tahoe-notifications | GNOME extension |
| 20 | tahoe-spotlight | Ulauncher config |
| 21 | tahoe-dock | Dash to Dock config |
| 22 | tahoe-terminal | Terminal theme |
| 23 | tahoe-backup | Time Machine app |
| 24 | tahoe-security | Firewall config |
| 25 | tahoe-window-manager | Window management |
| 26 | tahoe-lock-screen | Lock screen theme |
| 27 | tahoe-kernel-config | sysctl tuning |
| 28 | tahoe-browser | Firefox theme |
| 29 | tahoe-app-mapping | macOS app names |
| 30 | tahoe-shell-config | zsh + top bar |
| 31 | tahoe-accessibility | A11y settings |
| 32 | tahoe-help | Help app |
| 33 | tahoe-installer | Setup assistant |

---

## Troubleshooting

### Build fails with OOM
Increase RAM to 16GB or add swap:
```bash
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

### Theme not applying
Run after installing packages:
```bash
dconf update
fc-cache -f
dracut -f --regenerate-all
```

### Missing dependencies
Check DNF for any missing packages:
```bash
dnf install -y $(rpm -qpR packages/tahoe-*/tahoe-*.rpm 2>/dev/null | sort -u)
```

---

## Testing

Boot the ISO in a VM:
```bash
qemu-system-x86_64 -m 8G -enable-kvm \
    -cdrom iso/output/TahoeOS-2026.1-x86_64.iso
```

Or use VirtualBox with:
- 8GB RAM
- 64GB disk
- EFI enabled
- 3D acceleration enabled
