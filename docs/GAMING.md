# TahoeOS Gaming Documentation

## Gaming Stack

All gaming packages are available in Fedora 42 official repos or RPM Fusion.

### Compatibility Layers
| Component | Version | Source | Purpose |
|-----------|---------|--------|---------|
| Wine | 9.x stable | Fedora repos | Windows API translation |
| Proton-GE | Latest | GitHub releases | Enhanced Proton with extra fixes |
| DXVK | 2.7.x | Fedora repos | DirectX 9/10/11 → Vulkan |
| vkd3d-proton | Latest | Fedora repos | DirectX 12 → Vulkan |
| Winetricks | Latest | Fedora repos | Install Windows runtimes |

### Game Compositors & Tools
| Component | Source | Purpose |
|-----------|--------|---------|
| Gamescope | Fedora repos | SteamOS-like compositor (HDR, upscaling, frame limiting) |
| MangoHud | Fedora repos | FPS/performance overlay |
| Gamemode | Fedora repos | Auto CPU/GPU optimization on game launch |
| vkBasalt | Fedora repos | Post-processing (reshade for Linux) |
| GOverlay | Fedora repos | GUI for MangoHud/vkBasalt/Gamescope |

### Launchers
| Launcher | Purpose |
|----------|---------|
| Steam | Steam store + Proton integration |
| Lutris | Universal game manager |
| Heroic | Epic Games + GOG Galaxy |

### Pre-configured Runtimes
```
Visual C++ 2005-2022 Redistributable
.NET Framework 4.8
DirectX 9/10/11 Runtime
DirectX 12 (via vkd3d)
XAudio2
Media Foundation
Windows Fonts (core fonts)
```

## Wine Configuration

### Per-App Prefixes
```
~/.tahoe-wine/
├── AppName1/
│   ├── drive_c/
│   ├── user.reg
│   └── system.reg
├── AppName2/
│   └── ...
└── .runtimes-installed (flag file)
```

### File Associations
```
.exe  → tahoe-wine-handler (auto-install)
.msi  → tahoe-wine-handler (auto-install)
.msix → tahoe-wine-handler (auto-install)
.bat  → tahoe-wine-handler (auto-install)
```

## Hardware Optimization

### Kernel (Fedora 6.x)
```
- Default Fedora kernel (already optimized)
- Secure Boot compatible
- Official security updates
- BBR2 TCP congestion control
- zram enabled by default
```

### CPU Tuning
```
# /etc/sysctl.d/99-tahoeos-cpu.conf
kernel.sched_latency_ns = 4000000
kernel.sched_min_granularity_ns = 500000
kernel.sched_wakeup_granularity_ns = 50000
```

### RAM Tuning
```
# /etc/sysctl.d/99-tahoeos-ram.conf
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
```

### zram Configuration
```
# /etc/default/zramswap
ALGO=zstd
PERCENT=50
PRIORITY=100
```

### I/O Scheduler
```
NVMe: none (or mq-deadline)
SSD:  none
HDD:  bfq
```

### Process Priority (ananicy)
```
# /etc/ananicy.d/tahoeos.rules
{ "name": "steam",      "type": "Game" }
{ "name": "gamemode",   "type": "Game" }
{ "name": "wine",       "type": "Game" }
{ "name": "gamescope",  "type": "Game" }
{ "name": "lutris",     "type": "Game" }
```

## Default Gaming Config

### Gamescope (default)
```
# ~/.config/gamescope/gamescope.conf
--output-width 1920
--output-height 1080
--fullscreen
--grab
```

### MangoHud (default)
```
# ~/.config/MangoHud/MangoHud.conf
fps
gpu_stats
cpu_stats
ram
vram
frametime
```

### Gamemode
```
# /etc/gamemode.ini
[general]
renice=10
softrealtime=auto

[filter]
whitelist=steam
whitelist=lutris
whitelist=heroic
```
