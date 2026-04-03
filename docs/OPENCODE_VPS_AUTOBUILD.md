# TahoeOS OpenCode VPS Autobuild

## Use

1. SSH into the VPS and open the TahoeOS repository root.
2. Run `opencode`.
3. Paste the single prompt below as one message.

## Single-Paste Prompt

````text
Read `AGENTS.md`, `docs/README.md`, `docs/DECISIONS.md`, `docs/ARCHITECTURE.md`, `docs/PACKAGES.md`, `docs/BUILD.md`, `docs/ROADMAP.md`, `docs/GAMING.md`, `docs/SECURITY.md`, and all files under `docs/PHASES/` first. Build TahoeOS 2026.1 end-to-end in this repository. TahoeOS is Ubuntu 24.04 LTS (Noble Numbat)-based. Treat Ubuntu 24.04 LTS (Noble Numbat) as the authoritative base everywhere in code, scripts, packages, and docs touched by this work. Persist until the work is handled as far as possible in this session. Use the todo list immediately. Use task agents/subagents aggressively for independent workstreams. Do not stop to ask for confirmation unless blocked by missing credentials, missing external access, or an unreconcilable conflict. If documentation conflicts, keep all locked design decisions but resolve base-distro ambiguity in favor of Ubuntu 24.04 LTS (Noble Numbat), record the inconsistency in `docs/CHANGELOG.md`, and continue.

Execution rules:
- Read before write.
- Use `apply_patch` for manual edits.
- No comments in code unless absolutely required by existing style.
- Prefer minimal working implementations over ambitious incomplete ones.
- If art/assets are missing, create placeholder assets so the repo remains buildable.
- For shell scripts use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Make every shell script executable.
- Do not commit or push unless I later ask.
- Update `docs/CHANGELOG.md` as you complete major work.

Primary objective:
- Turn this repository from a docs/spec repo into a concrete TahoeOS implementation scaffold with build scripts, packages, apps, configs, CI/CD, repo tooling, fallback installer config, and verification commands wired together.

Start by inspecting the current tree, then create any missing directories from this structure:

```bash
mkdir -p build/{docker,scripts,live-build/{auto,hooks}}
mkdir -p installer/{qml/{screens,components,assets},src,assets}
mkdir -p packages/{tahoe-gtk-theme/{debian,src},tahoe-shell-theme/{debian,src},tahoe-icon-theme/{debian,src/{apps,places,devices,actions,categories,status}},tahoe-cursor-theme/{debian,src},tahoe-fonts/{debian,src},tahoe-wallpapers/{debian,src},tahoe-grub-theme/{debian,src},tahoe-plymouth-theme/{debian,src},tahoe-gdm-theme/{debian,src},tahoe-control-center/{debian,src/{panels,services,widgets},data/{ui,icons}},tahoe-app-store/{debian,src/{pages,backends,widgets},data},tahoe-gpu-manager/{debian,src,scripts},tahoe-wine-integration/{debian,src,config,scripts},tahoe-gaming/{debian,config,scripts},tahoe-update-manager/{debian,src,config,server},tahoe-notifications/{extension},tahoe-spotlight/{config},tahoe-dock/{config/theme},tahoe-terminal/{config},tahoe-branding/{debian,files,logos},tahoe-backup/{debian,src,config},tahoe-security/{debian,apparmor-profiles,ufw-profiles,unattended-upgrades},tahoe-window-manager/{extensions/{tahoe-mission-control,tahoe-hot-corners,tahoe-split-view,tahoe-stage-manager},config},tahoe-lock-screen/{extension/ui},tahoe-kernel-config/{debian,config},tahoe-browser/{profile/chrome,homepage},tahoe-app-mapping/{debian,desktop-entries},tahoe-shell-config/{gnome-shell-overrides,zsh},tahoe-help/{debian,src},tahoe-installer/{debian,qml/{screens,components,assets},src,assets}}
mkdir -p config/{dconf,skeleton/{.config/{plank,ulauncher,autostart,gtk-3.0,gtk-4.0,fontconfig},.local/share/applications},mimeapps,polkit,apparmor,ufw,zram,systemd/user}
mkdir -p calamares/{branding,modules}
mkdir -p apt-repo/{conf,gpg,scripts,nginx}
mkdir -p upgrade/{server,client}
mkdir -p branding/{logo,wordmark,fonts}
mkdir -p docs/PHASES
mkdir -p tests
mkdir -p iso/{amd64,arm64}
````

Then execute the work in waves, using subagents for independent workstreams and merging results carefully.

Wave 1: repository foundation
- Create `docs/CHANGELOG.md` if missing.
- Create `build/master.sh` as the master orchestrator that runs scripts `01` through `20` in order with logging and failure handling.
- Create `build/docker/Dockerfile` with the required Ubuntu 24.04 LTS (Noble Numbat) build tools needed by the current locked decisions and build docs.
- Create all build scripts in `build/scripts/`:
  - `01-debootstrap.sh`
  - `02-packages.sh`
  - `03-remove-bloat.sh`
  - `04-kernel.sh`
  - `05-themes.sh`
  - `06-icons.sh`
  - `07-apps.sh`
  - `08-gaming.sh`
  - `09-wine.sh`
  - `10-security.sh`
  - `11-backup.sh`
  - `12-window-mgmt.sh`
  - `13-shell.sh`
  - `14-vfs.sh`
  - `15-accessibility.sh`
  - `16-config.sh`
  - `17-branding.sh`
  - `18-block-snap.sh`
  - `19-cleanup.sh`
  - `20-iso.sh`
- Ensure the build scripts are consistent with the package and config paths created later.

Wave 2: parallel product workstreams
- Launch parallel subagents for these workstreams and keep them on separate file areas when possible:
  - Visual themes and branding assets.
  - Installer app.
  - Control Center app.
  - Gaming stack and kernel config.
  - Wine integration and App Store.
  - Backup, security, and update manager.
  - Window management, lock screen, and shell config.
  - App mapping, browser, and branding.
  - Small packages and utility apps.
  - System configuration files.
  - CI/CD, APT repo, and upgrade tooling.
  - Calamares fallback installer.

Implement the following package and app work in detail.

Visual themes and theme packages:
- Build `tahoe-gtk-theme`, `tahoe-shell-theme`, `tahoe-icon-theme`, `tahoe-cursor-theme`, `tahoe-fonts`, `tahoe-wallpapers`, `tahoe-grub-theme`, `tahoe-plymouth-theme`, and `tahoe-gdm-theme`.
- For each package create package metadata under `debian/` including at minimum `control`, install metadata, and any needed maintainer hooks.
- Use the repositories named in the docs as inspiration where appropriate, but keep the result TahoeOS-branded.
- Install locations must match the documented paths.
- If final art is unavailable, generate placeholder SVG/PNG assets and keep the package installable.

Installer:
- Create `installer/CMakeLists.txt`.
- Create `installer/src/main.cpp`.
- Create `installer/src/installer.cpp` and `installer/src/installer.h`.
- Create `installer/src/diskmanager.cpp` and `installer/src/diskmanager.h`.
- Create `installer/src/network.cpp` and `installer/src/network.h`.
- Create `installer/qml/main.qml`.
- Create reusable components under `installer/qml/components/`.
- Create screens under `installer/qml/screens/` for welcome, language, region, Wi-Fi, disk, account, privacy, theme, progress, and complete flows.
- Match the TahoeOS/macOS-inspired visual language while keeping the implementation buildable.

Control Center:
- Create `packages/tahoe-control-center/meson.build`.
- Create `packages/tahoe-control-center/src/main.py`.
- Create `packages/tahoe-control-center/src/window.py`.
- Create all panel modules under `packages/tahoe-control-center/src/panels/`:
  - `wifi.py`
  - `bluetooth.py`
  - `displays.py`
  - `sound.py`
  - `wallpaper.py`
  - `appearance.py`
  - `gpu_drivers.py`
  - `software_update.py`
  - `privacy.py`
  - `users.py`
  - `apps.py`
  - `keyboard.py`
  - `mouse_trackpad.py`
  - `about.py`
  - `startup_disk.py`
  - `energy.py`
  - `network.py`
- Create backend services under `packages/tahoe-control-center/src/services/`:
  - `gpu_detector.py`
  - `driver_installer.py`
  - `update_checker.py`
  - `update_downloader.py`
  - `network_manager.py`
- Create reusable widgets under `packages/tahoe-control-center/src/widgets/`.
- Ensure the app starts and the panel routing works even if some backend operations are placeholders.

Gaming stack and kernel tuning:
- Build `packages/tahoe-gaming` with scripts:
  - `install-proton-ge.sh`
  - `install-gamescope.sh`
  - `install-mangohud.sh`
  - `install-gamemode.sh`
  - `install-lutris.sh`
  - `install-heroic.sh`
  - `install-steam.sh`
- Create config files:
  - `gamescope.conf`
  - `mangohud.conf`
  - `gamemode.ini`
- Create package metadata in `packages/tahoe-gaming/debian/`.
- Build `packages/tahoe-kernel-config` with:
  - `config/99-tahoeos-sysctl.conf`
  - `config/99-tahoeos-limits.conf`
  - `config/99-tahoeos-udev.rules`
  - `config/ananicy.conf`
  - `config/tlp.conf`
  - install script and package metadata under `debian/`.

Wine integration and App Store:
- Build `packages/tahoe-wine-integration` with:
  - `src/tahoe-wine-handler.py`
  - `src/prefix_manager.py`
  - `src/icon_extractor.py`
  - `src/desktop_entry.py`
  - `src/uninstaller.py`
  - `config/mimeapps.list`
  - `config/wine-tahoe.desktop`
  - `scripts/setup-wine.sh`
- Build `packages/tahoe-app-store` with:
  - `meson.build`
  - `src/main.py`
  - `src/window.py`
  - `src/backends/apt_backend.py`
  - `src/backends/flatpak_backend.py`
  - `src/backends/wine_backend.py`
  - `src/widgets/app_card.py`
  - `data/featured.json`
- Ensure the app store UI and backend abstractions are connected.

Backup, security, and updates:
- Build `packages/tahoe-backup` with:
  - `src/tahoe-backup.py`
  - `src/snapshot_manager.py`
  - `src/timeline_viewer.py`
  - `src/restore.py`
  - `src/retention.py`
  - `config/tahoe-backup.conf`
  - `config/tahoe-backup.timer`
  - `config/tahoe-backup.service`
- Build `packages/tahoe-security` with:
  - AppArmor profiles for Tahoe apps and Firefox.
  - UFW default rules.
  - unattended-upgrades config.
  - install script and package metadata under `debian/`.
- Build `packages/tahoe-update-manager` with:
  - `src/update_daemon.py`
  - `src/update_manager.py`
  - `src/channel_manager.py`
  - `config/tahoe-sources.list`
  - `config/tahoe-update-daemon.service`
  - `server/setup-repo.sh`

Window management, lock screen, and shell config:
- Build `packages/tahoe-window-manager` with extensions:
  - `tahoe-mission-control`
  - `tahoe-hot-corners`
  - `tahoe-split-view`
  - `tahoe-stage-manager`
- Each extension should have `metadata.json`, implementation JS, and stylesheet assets where needed.
- Create `packages/tahoe-window-manager/config/hot-corners.conf` and install tooling.
- Build `packages/tahoe-lock-screen` with extension files, UI modules, stylesheet, and install tooling.
- Build `packages/tahoe-shell-config` with `gnome-shell-overrides/panel.js`, shell stylesheet, `.zshrc`, `.zprofile`, and install tooling.

App mapping, browser, and branding:
- Build `packages/tahoe-app-mapping` with desktop entries for Finder, Terminal, TextEdit, Calculator, Preview, Activity Monitor, Disk Utility, Screenshot, and App Store.
- Build `packages/tahoe-browser` with `userChrome.css`, `userContent.css`, `user.js`, homepage assets, and install tooling.
- Build `packages/tahoe-branding` with `os-release`, `lsb-release`, `issue`, `issue.net`, `neofetch.conf`, `fastfetch.json`, ASCII logo, and install tooling.

Small packages and utility apps:
- Build `tahoe-notifications`.
- Build `tahoe-spotlight`.
- Build `tahoe-dock`.
- Build `tahoe-terminal`.
- Build `tahoe-help` as a minimal GTK4 help viewer.
- Ensure each package has package metadata under `debian/` and install tooling.

Configuration:
- Create `config/dconf/tahoe.dconf` with TahoeOS GNOME defaults.
- Create the skeleton user config files under `config/skeleton/`.
- Create `config/mimeapps/mimeapps.list`.
- Create the required Polkit files.
- Create zram config.
- Create user systemd units for update and backup services.

CI/CD, APT repo, and upgrade system:
- Create `.github/workflows/build-iso.yml`.
- Create `.github/workflows/publish-packages.yml`.
- Create `.github/workflows/test-packages.yml`.
- Create `.github/workflows/release.yml`.
- Create GitHub issue templates and funding file.
- Create APT repo tooling:
  - `apt-repo/setup.sh`
  - `apt-repo/conf/distributions`
  - `apt-repo/conf/options`
  - `apt-repo/gpg/generate-key.sh`
  - `apt-repo/scripts/publish.sh`
  - `apt-repo/scripts/promote-beta-to-stable.sh`
  - `apt-repo/nginx/tahoeos-repo.conf`
- Create upgrade tooling:
  - `upgrade/server/upgrade-manifest.json`
  - `upgrade/server/publish-upgrade.sh`
  - `upgrade/client/tahoe-upgrade.py`
  - `upgrade/client/pre-upgrade-checks.sh`
  - `upgrade/client/create-pre-snapshot.sh`
  - `upgrade/client/post-upgrade.sh`

Calamares fallback:
- Create `calamares/branding/branding.desc`.
- Create `calamares/branding/show.qml`.
- Create module configs for welcome, locale, keyboard, partition, users, finished, and the master `settings.conf`.

Packaging requirements:
- Every package under `packages/tahoe-*` must have a `debian/control` file.
- Add install metadata and maintainer hooks where needed.
- Add minimal executable/buildable entry points for apps and scripts.
- Keep package names and install locations aligned with the project docs.

Verification requirements:
- Run `shellcheck` on shell scripts where available and fix issues.
- Run `desktop-file-validate` on desktop entries where available and fix issues.
- Run relevant syntax/build checks for Python, Meson, CMake, and QML where available.
- Run or dry-run the build flow enough to verify path consistency between scripts, packages, and configs.
- If a tool is missing, install it if reasonable; otherwise report the blocker clearly and continue with all other work.

Documentation requirements:
- Maintain `docs/CHANGELOG.md` with concise entries describing what you created.
- At the end, give a concise summary with:
  - directories and major files created
  - which workstreams are complete versus partial
  - validation commands run and outcomes
  - remaining blockers, if any
  - the exact next command I should run on the VPS

Work autonomously. Do the actual file creation and implementation now.
````

## Notes

- This prompt is tuned for unattended execution.
- It tells OpenCode to use subagents instead of requiring separate tabs.
- It now forces Ubuntu 24.04 LTS (Noble Numbat) as the authoritative base during execution.
