# TahoeOS Build Instructions

## Prerequisites

### Build Machine
- Linux VM (Fedora 42 recommended) or WSL2
- 4+ CPU cores
- 8+ GB RAM
- 50+ GB disk space
- Internet connection

### Required Tools
```bash
sudo dnf install -y \
  lorax \
  anaconda \
  livecd-tools \
  spin-kickstarts \
  squashfs-tools \
  xorriso \
  grub2-efi-x64 \
  grub2-efi-aa64 \
  mtools \
  dosfstools \
  qemu-system-x86 \
  qemu-system-aarch64
```

## Build Steps

### 1. Clone Repository
```bash
git clone https://github.com/YOURNAME/TahoeOS.git
cd TahoeOS
```

### 2. Run Master Build Script
```bash
chmod +x build/master.sh
sudo ./build/master.sh
```

### 3. Build Scripts Execute in Order
```
01-mock-setup.sh     → Create base Fedora 42 chroot
02-packages.sh       → Install all packages (dnf)
03-remove-bloat.sh   → Remove GNOME bloat
04-kernel.sh         → Kernel tuning (sysctl)
05-themes.sh         → Install all visual themes
06-icons.sh          → Install custom icon pack
07-apps.sh           → Install custom apps
08-gaming.sh         → Install gaming stack (all in repos!)
09-wine.sh           → Wine integration
10-security.sh       → Security stack
11-backup.sh         → Btrfs backup system
12-window-mgmt.sh    → Window management
13-shell.sh          → zsh + top bar config
14-vfs.sh            → Network/VFS support
15-accessibility.sh  → Accessibility
16-config.sh         → All configurations
17-branding.sh       → Replace ALL branding
18-block-snap.sh     → (Not needed, Fedora has no Snap)
19-cleanup.sh        → Final cleanup
20-iso.sh            → Build ISO (lorax/livemedia-creator)
```

### 4. Output
```
iso/output/TahoeOS-2026.1-amd64.iso  (~3.5 GB)
iso/output/TahoeOS-2026.1-arm64.iso  (~3.5 GB)
```

## Testing

### VirtualBox
```bash
# Create VM
VBoxManage createvm --name "TahoeOS" --ostype Ubuntu_64 --register
VBoxManage modifyvm "TahoeOS" --cpus 4 --memory 8192 --vram 128
VBoxManage modifyvm "TahoeOS" --graphicscontroller vmsvga --accelerate3d on
VBoxManage modifyvm "TahoeOS" --firmware efi
VBoxManage storagectl "TahoeOS" --name "SATA" --add sata
VBoxManage createhd --filename TahoeOS.vdi --size 65536
VBoxManage storageattach "TahoeOS" --storagectl "SATA" --port 0 --device 0 --type hdd --medium TahoeOS.vdi
VBoxManage storageattach "TahoeOS" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium iso/output/TahoeOS-2026.1-amd64.iso
VBoxManage startvm "TahoeOS"
```

### QEMU
```bash
qemu-system-x86_64 \
  -m 8G \
  -smp 4 \
  -enable-kvm \
  -vga virtio \
  -cdrom iso/output/TahoeOS-2026.1-amd64.iso \
  -drive file=test.qcow2,format=qcow2,if=virtio \
  -bios /usr/share/ovmf/OVMF.fd
```

### USB Boot
```bash
sudo dd if=iso/output/TahoeOS-2026.1-amd64.iso of=/dev/sdX bs=4M status=progress
```

## DNF/COPR Repository

### Setup
```bash
cd copr-repo/
chmod +x setup.sh
sudo ./setup.sh
```

### Publish Package
```bash
cd copr-repo/
./scripts/publish.sh ../packages/tahoe-gtk-theme/tahoe-gtk-theme-1.0-1.fc42.x86_64.rpm stable
```

### Promote Beta to Stable
```bash
cd copr-repo/
./scripts/promote-beta-to-stable.sh tahoe-gtk-theme
```

## CI/CD

GitHub Actions automatically:
1. Builds ISO on push to main
2. Publishes packages on changes to packages/
3. Creates release on tag

## Troubleshooting

### ISO won't boot
- Check UEFI settings
- Verify ISO integrity (sha256sum)
- Try Legacy BIOS mode

### Themes not applied
- Check gdm restarted
- Check dconf loaded
- Check icon cache rebuilt

### Gaming issues
- Verify Vulkan drivers installed (RPM Fusion)
- Check `vulkaninfo` output
- Check DXVK log: `~/.tahoe-wine/*/dxgi.log`
