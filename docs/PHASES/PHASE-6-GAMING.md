# Phase 6: Gaming

**Duration**: Week 5
**Goal**: Full gaming stack from day one

---

## Tasks

### 6.1 Gaming Stack Installation (P14)
- [ ] Wine 9.x stable (Fedora repos)
- [ ] Winetricks (Fedora repos)
- [ ] DXVK (Fedora repos)
- [ ] vkd3d-proton (Fedora repos)
- [ ] Gamescope (Fedora repos)
- [ ] MangoHud (Fedora repos)
- [ ] Gamemode (Fedora repos)
- [ ] Lutris (Fedora repos)
- [ ] Heroic (Flatpak)
- [ ] Steam (RPM Fusion)
- [ ] vkBasalt (Fedora repos)
- [ ] GOverlay (Fedora repos)

### 6.2 Pre-configured Runtimes
- [ ] Visual C++ 2005-2022
- [ ] .NET Framework 4.8
- [ ] DirectX 9/10/11/12
- [ ] XAudio2
- [ ] Media Foundation

### 6.3 Configuration
- [ ] Gamescope default config
- [ ] MangoHud default config
- [ ] Gamemode settings
- [ ] Steam Proton-GE setup
- [ ] DXVK cache pre-warming

### 6.4 HDR Support
- [ ] Gamescope HDR
- [ ] PipeWire HDR
- [ ] Display detection

### 6.5 NVIDIA Optimus
- [ ] Auto-detect hybrid GPU
- [ ] PRIME render offload
- [ ] Game on dGPU, idle on iGPU

### 6.6 Hardware Optimization
- [ ] Fedora kernel 6.x configuration
- [ ] sysctl tuning (99-tahoeos-sysctl.conf)
- [ ] I/O scheduler rules (NVMe=none, SSD=bfq, HDD=bfq)
- [ ] zram configuration (50% of RAM)
- [ ] TLP power management
- [ ] ananicy-cpp process priorities
- [ ] CPU governor tuning (schedutil default)

---

## Deliverables
- tahoe-gaming package
- tahoe-kernel-config package
- Full Proton/DXVK/vkd3d stack
- Pre-configured for gaming out of the box
- Hardware optimization configs
