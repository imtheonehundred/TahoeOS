# AGENTS.md

**Instructions for AI Agents working on TahoeOS**

---

## Project Context

TahoeOS is a complete Fedora 42 rebrand into a macOS 26 Tahoe-inspired Linux distribution. All 100 design decisions are locked. Do NOT change design decisions without user approval.

## Working Rules

1. **Read before write** — Always read existing files before modifying them
2. **Follow conventions** — Match existing code style, naming, and structure
3. **No comments in code** — Unless explicitly asked by user
4. **Test before done** — Run lint/typecheck commands when applicable
5. **Be concise** — Minimal output, no unnecessary explanations
6. **Parallel work** — Use multiple agents for independent tasks
7. **Document changes** — Update CHANGELOG.md for significant changes

## Project Structure

```
docs/              → All documentation
build/             → Build system (scripts, Docker, lorax)
installer/         → macOS setup assistant (QML + C++)
packages/          → 30 custom packages (themes, apps, services)
config/            → All configurations (dconf, skeleton, mimeapps)
upgrade/           → Version upgrade system
copr-repo/         → COPR repository management
calamares/         → Fallback installer
branding/          → Logo, wordmark, colors
iso/               → Build output
tests/             → Automated tests
.github/           → CI/CD workflows
```

## Package Naming Convention

```
tahoe-* (all custom packages)
Example: tahoe-gtk-theme, tahoe-control-center, tahoe-gpu-manager
```

## File Conventions

| Type | Location | Format |
|------|----------|--------|
| Themes | /usr/share/themes/TahoeOS/ | CSS, assets |
| Icons | /usr/share/icons/TahoeOS/ | SVG, PNG |
| Apps | /usr/bin/tahoe-* | Python + GTK4 |
| Config | /etc/tahoeos/ | .conf, .json |
| Services | /etc/systemd/system/ | .service, .timer |
| Scripts | /usr/lib/tahoeos/ | .sh, .py |

## Build Scripts Order

Scripts in `build/scripts/` run in numerical order:
```
01-mock-setup.sh → 02-packages.sh → 03-remove-bloat.sh →
04-kernel.sh → 05-themes.sh → 06-icons.sh → 07-apps.sh →
08-gaming.sh → 09-wine.sh → 10-security.sh → 11-backup.sh →
12-window-mgmt.sh → 13-shell.sh → 14-vfs.sh → 15-accessibility.sh →
16-config.sh → 17-branding.sh → 18-block-snap.sh → 19-cleanup.sh →
20-iso.sh
```

## Key Dependencies

| Package | Depends On |
|---------|-----------|
| tahoe-gtk-theme | sassc, inkscape |
| tahoe-shell-theme | gnome-shell |
| tahoe-control-center | python3-gi, gtk4, libadwaita |
| tahoe-app-store | python3-gi, flatpak |
| tahoe-gpu-manager | pciutils |
| tahoe-wine-integration | wine, winetricks |
| tahoe-gaming | wine, dxvk, vkd3d, gamescope |
| tahoe-update-manager | dnf, systemd |
| tahoe-backup | btrfs-progs, snapper |
| tahoe-installer | qt6-base, qt6-declarative |

## Testing

- Always test in VirtualBox VM before marking complete
- Run `shellcheck` on all .sh scripts
- Validate .desktop files with `desktop-file-validate`
- Check GTK CSS with `gtk-query-settings`

## Commands to Run After Changes

```bash
# Lint shell scripts
shellcheck build/scripts/*.sh

# Validate desktop files
desktop-file-validate packages/tahoe-app-mapping/desktop-entries/*.desktop

# Check package dependencies (RPM)
rpm -qpR packages/tahoe-*/tahoe-*.rpm

# Test ISO boot
qemu-system-x86_64 -m 8G -cdrom iso/output/TahoeOS-2026.1-amd64.iso
```

## Do NOT

- Change design decisions without user approval
- Add telemetry or phone-home
- Include Snap packages
- Remove Btrfs support
- Change license from MIT
- Add unnecessary dependencies
- Skip testing

## Communication

- Ask user before making architectural changes
- Show progress with todowrite tool
- Use task agents for parallel work
- Be proactive but don't surprise user
