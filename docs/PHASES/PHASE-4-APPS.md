# Phase 4: Core Apps

**Duration**: Week 3-4
**Goal**: Control Center, App Store, GPU Manager, Wine Integration

---

## Tasks

### 4.1 Tahoe Control Center (P10)
- [ ] Main window (sidebar + content panel)
- [ ] Wi-Fi panel
- [ ] Bluetooth panel
- [ ] Displays panel (resolution, scaling, night light, HDR)
- [ ] Sound panel
- [ ] Wallpaper panel
- [ ] Appearance panel (theme, accent, dock, icons)
- [ ] GPU Drivers panel (auto-detect + one-click install)
- [ ] Software Update panel (OTA updates + version upgrades)
- [ ] Privacy panel
- [ ] Users panel
- [ ] Apps panel (default apps, startup)
- [ ] Keyboard panel
- [ ] Mouse & Trackpad panel
- [ ] About panel (macOS-style system info)
- [ ] Startup Disk panel
- [ ] Energy panel (sleep, battery, power profiles)

### 4.2 Tahoe App Store (P11)
- [ ] Main window (Featured, Explore, Updates, Installed)
- [ ] rpm package backend (dnf)
- [ ] Flatpak backend
- [ ] Wine app backend
- [ ] App cards with ratings
- [ ] Install/Remove/Update flow
- [ ] Search functionality
- [ ] Category browsing
- [ ] Flatpak auto-theming

### 4.3 GPU Manager (P12)
- [ ] GPU detection (lspci)
- [ ] NVIDIA driver installer (RPM Fusion)
- [ ] AMD driver installer
- [ ] Intel driver installer
- [ ] Hybrid GPU switching (Optimus)
- [ ] Settings panel integration

### 4.4 Wine Integration (P13)
- [ ] .exe handler (tahoe-wine-handler.py)
- [ ] .msi handler
- [ ] Per-app Wine prefix creation
- [ ] Desktop entry generation
- [ ] Icon extraction from .exe
- [ ] MIME type associations
- [ ] VC++ / .NET / DirectX runtime installer
- [ ] Uninstaller

---

## Deliverables
- tahoe-control-center (full 17-panel Settings app)
- tahoe-app-store (unified store)
- tahoe-gpu-manager (auto-detect + install)
- tahoe-wine-integration (double-click .exe/.msi)
