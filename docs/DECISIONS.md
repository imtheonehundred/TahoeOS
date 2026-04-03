# TahoeOS Design Decisions

**All 100 decisions documented for reference.**

---

## 1. Core System (13 decisions)

| # | Category | Decision | Rationale |
|---|----------|----------|-----------|
| 1 | Base | Fedora 42 | All packages in repos (GNOME 48, Gamescope, DXVK, MangoHud), cutting-edge, gaming-friendly |
| 2 | Kernel | Fedora kernel (6.x) | Already optimized, Secure Boot works, official updates |
| 3 | Kernel updates | OTA via Settings | Seamless like macOS |
| 4 | Desktop | GNOME 48 + Liquid Glass | Best Wayland support, extensible, native in Fedora 42 |
| 5 | Display | Wayland + XWayland | Secure, smooth, X11 fallback for compat |
| 6 | Filesystem | Btrfs | Snapshots for Time Machine clone |
| 7 | Shell | zsh | macOS default, customizable prompt |
| 8 | Terminal | GNOME Terminal themed | Simple, works everywhere |
| 9 | File manager | Nautilus (Finder features) | Best GNOME integration |
| 10 | Browser | Firefox (Safari themed) | Privacy, extensible, Liquid Glass theme |
| 11 | Arch | x86_64 + ARM64 | Maximum hardware coverage |
| 12 | ISO size | ~3.5 GB | Everything included, no download needed |
| 13 | Release | Yearly major + monthly | Like macOS schedule |

## 2. Visual Design (11 decisions)

| # | Category | Decision |
|---|----------|----------|
| 14 | GTK theme | Liquid Glass (fork MacTahoe-gtk-theme) |
| 15 | Shell theme | Liquid Glass GNOME Shell |
| 16 | Icons | Full custom 200+ (1:1 macOS) |
| 17 | Cursor | macOS-style (Bibata-Modern-Apple) |
| 18 | Fonts | Inter + JetBrains Mono |
| 19 | Wallpapers | Custom Liquid Glass art |
| 20 | Sounds | macOS-style (chime, trash, screenshot, alert) |
| 21 | Animations | Full macOS (genie, bounce, smooth) |
| 22 | GRUB | Liquid Glass theme |
| 23 | Plymouth | Silent animated splash |
| 24 | GDM | Liquid Glass login screen |

## 3. Desktop Behavior (21 decisions)

| # | Category | Decision |
|---|----------|----------|
| 25 | Top bar | macOS clean (no Activities, centered clock) |
| 26 | Menu extras | Full (WiFi, battery, volume, BT, DND, calendar, weather) |
| 27 | Dock | Plank (magnification, auto-hide, trash) |
| 28 | Spotlight | Ulauncher + clipboard (Super+Space) |
| 29 | Shortcuts | Full macOS mapping (Super=Cmd) |
| 30 | Window mgmt | Mission Control + Exposé + Hot Corners + Split View + Stage Manager |
| 31 | App switcher | macOS-style (Super+Tab/+`) |
| 32 | Lock screen | macOS-style (big clock, avatar, blur) |
| 33 | Desktop icons | None (clean desktop) |
| 34 | Quick Look | Spacebar preview |
| 35 | Screenshot | macOS toolbar (Super+Shift+3/4/5) |
| 36 | Screen record | Built-in with toolbar |
| 37 | Widgets | macOS-style (transparent when windows open) |
| 38 | Notifications | macOS Notification Center (slide from right) |
| 39 | Night Light | Built-in (auto sunset/sunrise) |
| 40 | HDR | Supported |
| 41 | Multi-monitor | Full (per-monitor settings) |
| 42 | Color mgmt | Full ICC profiles (ColorSync clone) |
| 43 | Calendar | Widget + Google/CalDAV sync |
| 44 | Weather | Widget in Notification Center |
| 45 | File sharing | Right-click Samba |

## 4. Finder / Nautilus (8 decisions)

| # | Category | Decision |
|---|----------|----------|
| 46 | Network | Discovery in sidebar |
| 47 | Tags | Custom tags |
| 48 | Smart folders | Pre-configured + custom |
| 49 | Column view | Yes |
| 50 | Preview pane | Yes |
| 51 | Color labels | 7 macOS colors |
| 52 | Tab support | Yes |
| 53 | Quick actions | Yes |

## 5. Applications (5 decisions)

| # | Category | Decision |
|---|----------|----------|
| 54 | Apps | Ultra minimal (12 pre-installed) |
| 55 | App names | macOS mapping (Files→Finder, etc.) |
| 56 | App store | Unified (deb + Flatpak + Wine) |
| 57 | Flatpak remote | Flathub + TahoeOS curated |
| 58 | Snap | Blocked/removed |

## 6. System Services (14 decisions)

| # | Category | Decision |
|---|----------|----------|
| 59 | Flatpak theming | Auto-override |
| 60 | GPU | Auto-detect + one-click |
| 61 | Hybrid GPU | NVIDIA Optimus |
| 62 | Gaming | Full stack (Proton-GE + DXVK + vkd3d + Gamescope + etc.) |
| 63 | Wine | Per-app prefixes |
| 64 | Updates | OTA Stable + Beta |
| 65 | Upgrades | GUI in Settings |
| 66 | Security | Full stack (AppArmor + UFW + LUKS2 + TPM + Secure Boot) |
| 67 | Telemetry | Zero |
| 68 | Fingerprint | fprintd (Touch ID clone) |
| 69 | Backup | Time Machine clone (Btrfs) |
| 70 | Backup dest | Local + external + network |
| 71 | Drives | Auto-mount all formats |
| 72 | Trash | macOS sound effect |

## 7. Storage & Connectivity (15 decisions)

| # | Category | Decision |
|---|----------|----------|
| 73 | Archive | All formats |
| 74 | BT audio | All codecs (SBC, AAC, aptX, LDAC) |
| 75 | Printers | CUPS auto-detect |
| 76 | Dual boot | Auto-detect + GRUB entries |
| 77 | APFS/HFS+ | Read support |
| 78 | About panel | macOS-style |
| 79 | Neofetch/fastfetch | Pre-configured |
| 80 | Help | Built-in + online |
| 81 | Welcome | First boot tour |
| 82 | Languages | Top 20 |
| 83 | Timezone | Auto-detect |
| 84 | Firewall | Allow all outgoing |
| 85 | SSH | Not installed |
| 86 | Recovery | Partition + USB |
| 87 | Secure Boot | Supported |

## 8. Additional Features (13 decisions)

| # | Category | Decision |
|---|----------|----------|
| 88 | LUKS2 | TPM auto-unlock |
| 89 | Bug reporter | Built-in |
| 90 | Energy | Full macOS-style settings |
| 91 | Phone | GSConnect Android |
| 92 | GRUB menu | Full (recovery + memtest) |
| 93 | Build env | Linux VM (VirtualBox) |
| 94 | Source | GitHub |
| 95 | License | MIT |
| 96 | CI/CD | GitHub Actions |
| 97 | APT repo | VPS (reprepro + nginx) |
| 98 | Testing | VirtualBox |
| 99 | Logo | Design new (Tahoe mountain/lake) |
| 100 | Support | GitHub + Discord + Docs |

---

**Total: 100 decisions. All locked.**
