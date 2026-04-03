# Phase 3: Installer

**Duration**: Week 2-3
**Goal**: 1:1 macOS Tahoe setup assistant

---

## Tasks

### 3.1 QML Interface (9 screens)
- [ ] Welcome screen (language grid with flags)
- [ ] Region screen (map + keyboard layout)
- [ ] Wi-Fi screen (network list + connect)
- [ ] Disk selection screen (drive picker + encryption option)
- [ ] Account screen (create user + avatar)
- [ ] Appearance screen (light/dark + accent color)
- [ ] Privacy screen (telemetry toggles)
- [ ] Progress screen (animated install progress)
- [ ] Complete screen ("Welcome to TahoeOS")

### 3.2 Backend (C++)
- [ ] Disk detection and partitioning
- [ ] Btrfs subvolume creation
- [ ] dnf base system installation
- [ ] Package installation
- [ ] User account creation
- [ ] LUKS2 encryption setup
- [ ] TPM enrollment
- [ ] GRUB2 installation (UEFI + BIOS)
- [ ] Secure Boot shim enrollment
- [ ] Plymouth theme application
- [ ] All theme installation

### 3.3 Dual Boot Support
- [ ] Detect existing Windows partitions
- [ ] Detect existing macOS partitions (APFS/HFS+)
- [ ] Add entries to GRUB2
- [ ] Resize partitions safely

### 3.4 Testing
- [ ] Test on VirtualBox VM
- [ ] Test UEFI boot
- [ ] Test Legacy BIOS boot
- [ ] Test encryption workflow
- [ ] Test dual boot workflow

---

## Deliverables
- tahoe-installer package
- 9 QML screens (1:1 macOS clone)
- Working backend for full installation
- Dual boot support
