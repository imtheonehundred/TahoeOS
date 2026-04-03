# Phase 5: System Services

**Duration**: Week 4-5
**Goal**: Updates, Upgrades, Backup, Security, Window Management

---

## Tasks

### 5.1 Update Manager (P15)
- [ ] Update daemon (systemd service)
- [ ] dnf repo polling
- [ ] Changelog parsing
- [ ] D-Bus notification to Control Center
- [ ] Download + install flow
- [ ] Pre-update Btrfs snapshot
- [ ] Stable/Beta channel switching
- [ ] Kernel update handling

### 5.2 Version Upgrade System
- [ ] Upgrade manifest format
- [ ] Upgrade orchestrator (tahoe-upgrade.py)
- [ ] Pre-upgrade checks
- [ ] Pre-upgrade Btrfs snapshot
- [ ] Package upgrade (dnf system-upgrade)
- [ ] Post-upgrade cleanup
- [ ] Settings panel integration

### 5.3 Tahoe Backup (P21)
- [ ] Snapshot manager (Btrfs)
- [ ] Hourly timer
- [ ] Retention policy
- [ ] Timeline browser
- [ ] File restore
- [ ] System restore
- [ ] GRUB snapshot entries
- [ ] External drive backup
- [ ] Network drive backup (SMB/NFS)
- [ ] Pre-update snapshots
- [ ] Settings panel integration

### 5.4 Security (P22)
- [ ] SELinux policies for all apps
- [ ] firewalld default rules
- [ ] Firewall GUI in Settings
- [ ] dnf-automatic config
- [ ] LUKS2 + TPM in installer
- [ ] fprintd integration

### 5.5 Window Management (P23)
- [ ] Mission Control extension
- [ ] App Exposé
- [ ] Hot Corners configuration
- [ ] Split View (drag to edge)
- [ ] Stage Manager extension
- [ ] macOS Alt-Tab switcher

### 5.6 Lock Screen (P24)
- [ ] Big clock display
- [ ] User avatar
- [ ] Blur background
- [ ] Smooth unlock animation
- [ ] Notification display
- [ ] Media controls
- [ ] Fingerprint support

### 5.7 Notifications (P16)
- [ ] macOS-style notification banners
- [ ] Notification Center (slide from right)
- [ ] Today view with widgets
- [ ] Do Not Disturb toggle
- [ ] Calendar widget
- [ ] Weather widget

### 5.8 Shell Config (P28)
- [ ] Remove Activities button
- [ ] Center clock
- [ ] Add TahoeOS menu
- [ ] macOS-style app menu
- [ ] zsh configuration
- [ ] macOS-style prompt

---

## Deliverables
- tahoe-update-manager (OTA updates + version upgrades)
- tahoe-backup (Time Machine clone)
- tahoe-security (full stack)
- tahoe-window-manager (Mission Control + all)
- tahoe-lock-screen (macOS-style)
- tahoe-notifications (macOS-style)
- tahoe-shell-config (clean top bar + zsh)
