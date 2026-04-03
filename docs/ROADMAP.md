# TahoeOS Roadmap

## Timeline

```
Week 1  ──── Foundations ──────────────────────────────
│ Build environment (Linux VM, Docker)
│ GitHub repository setup
│ APT repo server (VPS)
│ Logo design
│ CI/CD (GitHub Actions)
│
Week 2  ──── Visual Themes ────────────────────────────
│ Liquid Glass GTK theme (fork + customize)
│ GNOME Shell theme
│ Custom icon pack (200+ icons)
│ Cursor theme
│ Fonts (Inter + JetBrains Mono)
│ GRUB theme
│ Plymouth boot splash
│ GDM login theme
│ Wallpapers
│ System sounds
│
Week 3  ──── Installer + Apps ─────────────────────────
│ macOS setup assistant (QML, 9 screens)
│ Tahoe Control Center (all 14 panels)
│ GPU driver panel + auto-detect
│ Software Update panel
│
Week 4  ──── Services + Integration ───────────────────
│ Tahoe App Store (deb + Flatpak + Wine)
│ GPU auto-detect + one-click install
│ Wine integration (.exe/.msi handler)
│ Full gaming stack
│ OTA update system
│ Version upgrade system
│
Week 5  ──── System Features ──────────────────────────
│ Tahoe Backup (Time Machine clone)
│ Security stack (AppArmor, UFW, LUKS2)
│ Window management (Mission Control, etc.)
│ Lock screen
│ Notifications
│ Shell config (zsh + top bar)
│
Week 6  ──── Configuration ────────────────────────────
│ All dconf settings
│ App mapping (renamed desktop entries)
│ Bloat removal
│ Browser theming (Firefox → Safari style)
│ Flatpak auto-theming
│ Accessibility
│ Printing
│ VFS (network shares)
│
Week 7  ──── Integration ──────────────────────────────
│ Full system integration
│ ISO build (first attempt)
│ VM testing
│ Bug fixes
│
Week 8  ──── Polish + Release ─────────────────────────
│ Final bug fixes
│ Documentation
│ Release notes
│ ISO distribution
│
WEEK 8+: TahoeOS 2026.1 RELEASED
```

## Milestones

| Milestone | Target | Deliverable |
|-----------|--------|-------------|
| M1 | Week 1 | Build environment ready, repo online |
| M2 | Week 2 | All visual themes complete |
| M3 | Week 3 | Installer + Control Center working |
| M4 | Week 4 | App Store + Gaming ready |
| M5 | Week 5 | Backup + Security + Window mgmt ready |
| M6 | Week 6 | Full config + bloat removal |
| M7 | Week 7 | First bootable ISO |
| M8 | Week 8 | Stable ISO release |

## Post-Release Roadmap

### TahoeOS 2026.2 (Q3 2026)
- Bug fixes from community feedback
- Performance optimizations
- New wallpapers
- Updated gaming stack
- Additional languages

### TahoeOS 2026.3 (Q4 2026)
- GNOME 49 support (if released)
- Updated kernel
- New features from community requests

### TahoeOS 2027.1 (Q1 2027)
- Major version upgrade
- Ubuntu 26.04 LTS base (if available)
- Full design refresh
- New features
- Available via Settings → Software Update → Upgrade Now

## Parallel Agent Allocation

| Agents | Working On |
|--------|-----------|
| Agent 1-3 | Visual themes (GTK, Shell, Icons, GRUB, Plymouth, GDM) |
| Agent 4-5 | Installer (QML screens + backend) |
| Agent 6-7 | Control Center + App Store |
| Agent 8 | Gaming stack + Wine integration |
