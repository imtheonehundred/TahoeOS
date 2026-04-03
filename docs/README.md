# TahoeOS 2026.1

**A macOS 26 Tahoe-inspired Linux distribution built on Fedora 42**

---

## Overview

TahoeOS is a complete rebrand and redesign of Fedora 42, bringing the macOS 26 Tahoe experience to the Linux desktop. Every pixel, every interaction, every system behavior is designed to replicate the Liquid Glass aesthetic and macOS user experience — with the power and flexibility of Linux underneath.

## Key Features

- **Liquid Glass UI** — Full macOS 26 Tahoe visual design (translucent glass, rounded corners, blur effects)
- **macOS Installer** — 1:1 clone of the macOS Tahoe setup assistant (QML)
- **Full Gaming Support** — Proton-GE, DXVK, vkd3d, DX11/DX12, Gamescope, Steam, Lutris, Heroic
- **Windows App Support** — Double-click .exe/.msi files, auto-install as native apps
- **GPU Auto-Detect** — One-click driver install for NVIDIA, AMD, Intel from Settings
- **OTA Updates** — macOS-style updates in Settings panel (Stable + Beta channels)
- **Version Upgrades** — Major version upgrades (2026.1 → 2027.1) with GUI in Settings
- **Time Machine Backup** — Btrfs snapshot-based backup with timeline UI
- **Full Security** — AppArmor, UFW, LUKS2 encryption, TPM auto-unlock, Secure Boot
- **macOS Window Management** — Mission Control, Hot Corners, Split View, Stage Manager
- **Hardware Optimization** — Fedora kernel 6.x, zram, CPU/GPU/RAM tuning
- **Custom App Store** — Unified store for rpm + Flatpak + Wine apps

## Architecture

| Layer | Component |
|-------|-----------|
| Base | Fedora 42 |
| Kernel | Fedora 6.x (optimized, Secure Boot ready) |
| Desktop | GNOME 48 + Liquid Glass theme |
| Display | Wayland + XWayland |
| Filesystem | Btrfs (snapshots, compression) |
| Shell | zsh with macOS-style prompt |
| Package | rpm + Flatpak (no Snap) |

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](ARCHITECTURE.md) | System architecture and stack |
| [Decisions](DECISIONS.md) | All 100 design decisions |
| [Roadmap](ROADMAP.md) | Timeline and milestones |
| [Packages](PACKAGES.md) | All 30 custom packages |
| [Gaming](GAMING.md) | Gaming stack documentation |
| [Security](SECURITY.md) | Security architecture |
| [Build](BUILD.md) | Build instructions |

## Phases

| Phase | Document | Duration |
|-------|----------|----------|
| 1. Foundations | [PHASE-1](PHASES/PHASE-1-FOUNDATIONS.md) | Week 1 |
| 2. Visual Themes | [PHASE-2](PHASES/PHASE-2-VISUAL-THEMES.md) | Week 2 |
| 3. Installer | [PHASE-3](PHASES/PHASE-3-INSTALLER.md) | Week 2-3 |
| 4. Core Apps | [PHASE-4](PHASES/PHASE-4-APPS.md) | Week 3-4 |
| 5. Services | [PHASE-5](PHASES/PHASE-5-SERVICES.md) | Week 4-5 |
| 6. Gaming | [PHASE-6](PHASES/PHASE-6-GAMING.md) | Week 5 |
| 7. Security & Backup | [PHASE-7](PHASES/PHASE-7-SECURITY-BACKUP.md) | Week 5-6 |
| 8. Config & Branding | [PHASE-8](PHASES/PHASE-8-CONFIG-BRANDING.md) | Week 6-7 |
| 9. ISO & Testing | [PHASE-9](PHASES/PHASE-9-ISO-TESTING.md) | Week 7-8 |

## Reports

| Report | Language |
|--------|----------|
| [English Report](REPORT-EN.md) | English |
| [Arabic Report](REPORT-AR.md) | العربية |

## License

MIT License — see [LICENSE](../LICENSE) for details.

## Links

- **Source**: github.com/YOURNAME/TahoeOS
- **Website**: docs.tahoeos.com (planned)
- **Discord**: discord.gg/tahoeos (planned)
- **COPR Repo**: copr.tahoeos.com (planned)

---

*TahoeOS 2026.1 — The Linux that looks like macOS.*
