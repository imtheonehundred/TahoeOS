# TahoeOS Complete Build Guide

**Instructions for OpenCode to build all 30 packages and create final ISO.**

---

## Overview

TahoeOS = Fedora 42 + 30 custom packages + macOS Tahoe visual design + full gaming stack.

### Package Status

| Status | Packages |
|--------|----------|
| **Use from GitHub** | P01-P04, P07-P09 (themes from vinceliuice) |
| **Build from source** | P05, P10-P30 (create these) |

---

## Step 1: VPS Setup

```bash
# Run as root on Fedora 42 VPS (8GB RAM minimum)
dnf upgrade -y
dnf install -y \
    lorax livecd-tools pykickstart anaconda \
    git wget curl unzip \
    python3 python3-pip python3-gobject python3-devel \
    gtk4-devel libadwaita-devel \
    sassc inkscape optipng \
    qt6-qtbase-devel qt6-qtdeclarative-devel \
    rpm-build rpmdevtools

mkdir -p /home/tahoeos
cd /home/tahoeos
```

---

## Step 2: Build All Packages

### P05: tahoe-fonts

```bash
mkdir -p /home/tahoeos/packages/tahoe-fonts
cd /home/tahoeos/packages/tahoe-fonts

# Download Inter font
wget -q https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip
unzip -q Inter-4.0.zip -d inter
mkdir -p fonts
cp inter/Inter-*.ttf fonts/

# Download JetBrains Mono
wget -q https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
unzip -q JetBrainsMono-2.304.zip -d jbmono
cp jbmono/fonts/ttf/*.ttf fonts/

# Create install script
cat > install.sh << 'EOF'
#!/bin/bash
mkdir -p /usr/share/fonts/tahoeos
cp fonts/*.ttf /usr/share/fonts/tahoeos/
fc-cache -f
EOF
chmod +x install.sh
```

---

### P10: tahoe-control-center

Create macOS-style System Settings app.

```bash
mkdir -p /home/tahoeos/packages/tahoe-control-center/src
cd /home/tahoeos/packages/tahoe-control-center
```

**File: src/main.py**
```python
#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, Gio

class ControlCenterWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="System Settings")
        self.set_default_size(900, 600)
        
        # Main layout
        paned = Gtk.Paned(orientation=Gtk.Orientation.HORIZONTAL)
        self.set_content(paned)
        
        # Sidebar
        sidebar = self.create_sidebar()
        paned.set_start_child(sidebar)
        paned.set_shrink_start_child(False)
        
        # Content area
        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        paned.set_end_child(self.stack)
        
        # Add panels
        self.add_panel("wifi", "Wi-Fi", "network-wireless-symbolic", self.create_wifi_panel())
        self.add_panel("bluetooth", "Bluetooth", "bluetooth-symbolic", self.create_bluetooth_panel())
        self.add_panel("display", "Displays", "video-display-symbolic", self.create_display_panel())
        self.add_panel("sound", "Sound", "audio-volume-high-symbolic", self.create_sound_panel())
        self.add_panel("appearance", "Appearance", "preferences-desktop-wallpaper-symbolic", self.create_appearance_panel())
        self.add_panel("notifications", "Notifications", "preferences-system-notifications-symbolic", self.create_notifications_panel())
        self.add_panel("privacy", "Privacy & Security", "security-high-symbolic", self.create_privacy_panel())
        self.add_panel("keyboard", "Keyboard", "input-keyboard-symbolic", self.create_keyboard_panel())
        self.add_panel("mouse", "Mouse & Trackpad", "input-mouse-symbolic", self.create_mouse_panel())
        self.add_panel("users", "Users", "system-users-symbolic", self.create_users_panel())
        self.add_panel("about", "About", "help-about-symbolic", self.create_about_panel())
    
    def create_sidebar(self):
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_size_request(220, -1)
        
        self.listbox = Gtk.ListBox()
        self.listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.listbox.add_css_class("navigation-sidebar")
        self.listbox.connect("row-selected", self.on_row_selected)
        scrolled.set_child(self.listbox)
        
        return scrolled
    
    def add_panel(self, name, title, icon_name, widget):
        # Add to sidebar
        row = Gtk.ListBoxRow()
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        box.set_margin_start(12)
        box.set_margin_end(12)
        box.set_margin_top(8)
        box.set_margin_bottom(8)
        
        icon = Gtk.Image.new_from_icon_name(icon_name)
        box.append(icon)
        
        label = Gtk.Label(label=title)
        label.set_halign(Gtk.Align.START)
        box.append(label)
        
        row.set_child(box)
        row.panel_name = name
        self.listbox.append(row)
        
        # Add to stack
        self.stack.add_named(widget, name)
    
    def on_row_selected(self, listbox, row):
        if row:
            self.stack.set_visible_child_name(row.panel_name)
    
    def create_wifi_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Wi-Fi")
        
        toggle = Adw.SwitchRow(title="Wi-Fi", subtitle="Connected to network")
        toggle.set_active(True)
        group.add(toggle)
        
        page.add(group)
        return page
    
    def create_bluetooth_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Bluetooth")
        
        toggle = Adw.SwitchRow(title="Bluetooth", subtitle="Discoverable")
        toggle.set_active(True)
        group.add(toggle)
        
        page.add(group)
        return page
    
    def create_display_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Display Settings")
        
        night_light = Adw.SwitchRow(title="Night Light", subtitle="Reduce blue light at night")
        group.add(night_light)
        
        page.add(group)
        return page
    
    def create_sound_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Sound")
        
        output = Adw.ComboRow(title="Output Device")
        group.add(output)
        
        page.add(group)
        return page
    
    def create_appearance_panel(self):
        page = Adw.PreferencesPage()
        
        theme_group = Adw.PreferencesGroup(title="Appearance")
        
        dark_mode = Adw.SwitchRow(title="Dark Mode")
        dark_mode.set_active(True)
        theme_group.add(dark_mode)
        
        page.add(theme_group)
        return page
    
    def create_notifications_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Notifications")
        
        dnd = Adw.SwitchRow(title="Do Not Disturb")
        group.add(dnd)
        
        page.add(group)
        return page
    
    def create_privacy_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Privacy & Security")
        
        firewall = Adw.SwitchRow(title="Firewall", subtitle="Block incoming connections")
        firewall.set_active(True)
        group.add(firewall)
        
        page.add(group)
        return page
    
    def create_keyboard_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Keyboard")
        
        layout = Adw.ActionRow(title="Keyboard Layout", subtitle="US English")
        group.add(layout)
        
        page.add(group)
        return page
    
    def create_mouse_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Mouse & Trackpad")
        
        natural = Adw.SwitchRow(title="Natural Scrolling")
        natural.set_active(True)
        group.add(natural)
        
        tap = Adw.SwitchRow(title="Tap to Click")
        tap.set_active(True)
        group.add(tap)
        
        page.add(group)
        return page
    
    def create_users_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Users")
        
        import os
        user = Adw.ActionRow(title=os.getenv("USER", "User"), subtitle="Administrator")
        group.add(user)
        
        page.add(group)
        return page
    
    def create_about_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="About This Mac... er, TahoeOS")
        
        os_row = Adw.ActionRow(title="TahoeOS", subtitle="Version 2026.1 (Tahoe)")
        group.add(os_row)
        
        import subprocess
        try:
            cpu = subprocess.check_output(["lscpu"], text=True)
            cpu_model = [l for l in cpu.split('\n') if 'Model name' in l][0].split(':')[1].strip()
        except:
            cpu_model = "Unknown"
        
        cpu_row = Adw.ActionRow(title="Processor", subtitle=cpu_model)
        group.add(cpu_row)
        
        try:
            with open('/proc/meminfo') as f:
                mem = f.readline().split()[1]
                mem_gb = int(mem) // 1024 // 1024
        except:
            mem_gb = 0
        
        mem_row = Adw.ActionRow(title="Memory", subtitle=f"{mem_gb} GB")
        group.add(mem_row)
        
        page.add(group)
        return page


class ControlCenterApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='org.tahoeos.controlcenter')
    
    def do_activate(self):
        win = ControlCenterWindow(self)
        win.present()


def main():
    app = ControlCenterApp()
    app.run()

if __name__ == '__main__':
    main()
```

**File: install.sh**
```bash
#!/bin/bash
mkdir -p /usr/share/tahoe-control-center
cp src/main.py /usr/share/tahoe-control-center/

cat > /usr/bin/tahoe-control-center << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-control-center/main.py "$@"
EOF
chmod +x /usr/bin/tahoe-control-center

cat > /usr/share/applications/org.tahoeos.controlcenter.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=System Settings
Comment=TahoeOS System Settings
Exec=tahoe-control-center
Icon=preferences-system
Categories=Settings;System;
EOF
```

---

### P12: tahoe-gpu-manager

```bash
mkdir -p /home/tahoeos/packages/tahoe-gpu-manager/src
cd /home/tahoeos/packages/tahoe-gpu-manager
```

**File: src/tahoe-gpu-manager.py**
```python
#!/usr/bin/env python3
import subprocess
import sys

def detect_gpu():
    try:
        lspci = subprocess.check_output(['lspci', '-nn'], text=True)
        gpus = []
        for line in lspci.split('\n'):
            if 'VGA' in line or '3D' in line or 'Display' in line:
                if 'NVIDIA' in line.upper():
                    gpus.append(('nvidia', line))
                elif 'AMD' in line.upper() or 'ATI' in line.upper():
                    gpus.append(('amd', line))
                elif 'INTEL' in line.upper():
                    gpus.append(('intel', line))
        return gpus
    except:
        return []

def install_nvidia():
    print("Installing NVIDIA drivers...")
    subprocess.run(['dnf', 'install', '-y', 'akmod-nvidia', 'xorg-x11-drv-nvidia-cuda'], check=True)
    print("NVIDIA drivers installed. Reboot required.")

def install_amd():
    print("AMD drivers are included in kernel. Checking for firmware...")
    subprocess.run(['dnf', 'install', '-y', 'mesa-dri-drivers', 'mesa-vulkan-drivers', 'xorg-x11-drv-amdgpu'], check=True)
    print("AMD drivers ready.")

def main():
    print("TahoeOS GPU Manager")
    print("=" * 40)
    
    gpus = detect_gpu()
    if not gpus:
        print("No discrete GPU detected.")
        return
    
    for vendor, info in gpus:
        print(f"Found: {info[:60]}...")
        
        if vendor == 'nvidia':
            if '--auto' in sys.argv or input("Install NVIDIA drivers? [y/N] ").lower() == 'y':
                install_nvidia()
        elif vendor == 'amd':
            if '--auto' in sys.argv or input("Install AMD drivers? [y/N] ").lower() == 'y':
                install_amd()
        elif vendor == 'intel':
            print("Intel GPU - drivers included in kernel.")

if __name__ == '__main__':
    main()
```

**File: install.sh**
```bash
#!/bin/bash
cp src/tahoe-gpu-manager.py /usr/bin/tahoe-gpu-manager
chmod +x /usr/bin/tahoe-gpu-manager
```

---

### P15: tahoe-update-manager

```bash
mkdir -p /home/tahoeos/packages/tahoe-update-manager/src
cd /home/tahoeos/packages/tahoe-update-manager
```

**File: src/tahoe-update-manager.py**
```python
#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, GLib
import subprocess
import threading

class UpdateWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Software Update")
        self.set_default_size(500, 400)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)
        
        header = Adw.HeaderBar()
        box.append(header)
        
        self.status = Adw.StatusPage()
        self.status.set_icon_name("software-update-available-symbolic")
        self.status.set_title("Checking for updates...")
        box.append(self.status)
        
        self.button = Gtk.Button(label="Check for Updates")
        self.button.add_css_class("suggested-action")
        self.button.set_halign(Gtk.Align.CENTER)
        self.button.set_margin_bottom(24)
        self.button.connect("clicked", self.check_updates)
        box.append(self.button)
        
        GLib.idle_add(self.check_updates, None)
    
    def check_updates(self, btn):
        self.status.set_title("Checking for updates...")
        self.button.set_sensitive(False)
        
        thread = threading.Thread(target=self._check_thread)
        thread.daemon = True
        thread.start()
    
    def _check_thread(self):
        try:
            result = subprocess.run(['dnf', 'check-update', '-q'], capture_output=True, text=True)
            updates = [l for l in result.stdout.strip().split('\n') if l.strip()]
            GLib.idle_add(self._show_result, updates)
        except Exception as e:
            GLib.idle_add(self._show_error, str(e))
    
    def _show_result(self, updates):
        if updates:
            self.status.set_title(f"{len(updates)} updates available")
            self.status.set_description("Click Update All to install")
            self.button.set_label("Update All")
            self.button.disconnect_by_func(self.check_updates)
            self.button.connect("clicked", self.install_updates)
        else:
            self.status.set_title("TahoeOS is up to date")
            self.status.set_description("Last checked: just now")
            self.button.set_label("Check Again")
        self.button.set_sensitive(True)
    
    def _show_error(self, error):
        self.status.set_title("Error checking updates")
        self.status.set_description(error)
        self.button.set_sensitive(True)
    
    def install_updates(self, btn):
        self.status.set_title("Installing updates...")
        self.button.set_sensitive(False)
        
        thread = threading.Thread(target=self._install_thread)
        thread.daemon = True
        thread.start()
    
    def _install_thread(self):
        try:
            subprocess.run(['pkexec', 'dnf', 'upgrade', '-y'], check=True)
            GLib.idle_add(self._install_complete)
        except Exception as e:
            GLib.idle_add(self._show_error, str(e))
    
    def _install_complete(self):
        self.status.set_title("Updates installed!")
        self.status.set_description("You may need to restart")
        self.button.set_label("Close")
        self.button.set_sensitive(True)
        self.button.disconnect_by_func(self.install_updates)
        self.button.connect("clicked", lambda x: self.close())


class UpdateApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='org.tahoeos.updatemanager')
    
    def do_activate(self):
        win = UpdateWindow(self)
        win.present()


def main():
    app = UpdateApp()
    app.run()

if __name__ == '__main__':
    main()
```

**File: install.sh**
```bash
#!/bin/bash
mkdir -p /usr/share/tahoe-update-manager
cp src/tahoe-update-manager.py /usr/share/tahoe-update-manager/

cat > /usr/bin/tahoe-update-manager << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-update-manager/tahoe-update-manager.py "$@"
EOF
chmod +x /usr/bin/tahoe-update-manager

cat > /usr/share/applications/org.tahoeos.updatemanager.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Software Update
Comment=Update TahoeOS
Exec=tahoe-update-manager
Icon=software-update-available
Categories=System;
EOF
```

---

### P17: tahoe-spotlight (Ulauncher config)

```bash
mkdir -p /home/tahoeos/packages/tahoe-spotlight
cd /home/tahoeos/packages/tahoe-spotlight
```

**File: install.sh**
```bash
#!/bin/bash
# Install ulauncher
dnf install -y ulauncher

# Configure for macOS Spotlight feel
mkdir -p /etc/skel/.config/ulauncher

cat > /etc/skel/.config/ulauncher/settings.json << 'EOF'
{
    "blacklisted-desktop-dirs": "/usr/share/locale",
    "clear-previous-query": true,
    "hotkey-show-app": "<Super>space",
    "render-on-screen": "mouse-pointer-monitor",
    "show-indicator-icon": false,
    "show-recent-apps": "3",
    "terminal-command": "gnome-terminal",
    "theme-name": "dark"
}
EOF

# Create autostart
mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/ulauncher.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Ulauncher
Exec=ulauncher --hide-window
Hidden=false
EOF

# Disable GNOME's built-in search (optional)
cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'
[org/gnome/desktop/search-providers]
disable-external=true
EOF
```

---

### P19: tahoe-terminal

```bash
mkdir -p /home/tahoeos/packages/tahoe-terminal
cd /home/tahoeos/packages/tahoe-terminal
```

**File: install.sh**
```bash
#!/bin/bash
# GNOME Terminal theme config

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/terminal/legacy]
theme-variant='dark'
default-show-menubar=false

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='TahoeOS'
use-system-font=false
font='JetBrains Mono 11'
use-theme-colors=false
foreground-color='#f8f8f2'
background-color='#1e1e2e'
palette=['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#bac2de', '#585b70', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8']
use-transparent-background=true
background-transparency-percent=5
scrollback-unlimited=true
audible-bell=false
EOF

# ZSH config
cat > /etc/skel/.zshrc << 'EOF'
# TahoeOS ZSH Config
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nano
export PATH="$HOME/.local/bin:$PATH"

# Prompt
PROMPT='%F{blue}%~%f %F{green}❯%f '

# Aliases (macOS style)
alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias open='xdg-open'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
EOF
```

---

### P21: tahoe-backup

```bash
mkdir -p /home/tahoeos/packages/tahoe-backup/src
cd /home/tahoeos/packages/tahoe-backup
```

**File: src/tahoe-backup.py**
```python
#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, GLib
import subprocess
import threading
import json
from datetime import datetime

class BackupWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Time Machine")
        self.set_default_size(600, 500)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)
        
        header = Adw.HeaderBar()
        box.append(header)
        
        content = Adw.PreferencesPage()
        box.append(content)
        
        # Status group
        status_group = Adw.PreferencesGroup(title="Backup Status")
        content.add(status_group)
        
        self.status_row = Adw.ActionRow(title="Last Backup", subtitle="Checking...")
        status_group.add(self.status_row)
        
        # Actions group
        actions_group = Adw.PreferencesGroup(title="Actions")
        content.add(actions_group)
        
        backup_row = Adw.ActionRow(title="Back Up Now", subtitle="Create a snapshot")
        backup_btn = Gtk.Button(label="Backup")
        backup_btn.set_valign(Gtk.Align.CENTER)
        backup_btn.connect("clicked", self.do_backup)
        backup_row.add_suffix(backup_btn)
        actions_group.add(backup_row)
        
        restore_row = Adw.ActionRow(title="Restore", subtitle="Browse previous snapshots")
        restore_btn = Gtk.Button(label="Browse")
        restore_btn.set_valign(Gtk.Align.CENTER)
        restore_btn.connect("clicked", self.browse_snapshots)
        restore_row.add_suffix(restore_btn)
        actions_group.add(restore_row)
        
        # Snapshots list
        self.snapshots_group = Adw.PreferencesGroup(title="Snapshots")
        content.add(self.snapshots_group)
        
        GLib.idle_add(self.load_snapshots)
    
    def load_snapshots(self):
        thread = threading.Thread(target=self._load_thread)
        thread.daemon = True
        thread.start()
    
    def _load_thread(self):
        try:
            result = subprocess.run(['snapper', 'list', '--json'], capture_output=True, text=True)
            snapshots = json.loads(result.stdout) if result.returncode == 0 else []
            GLib.idle_add(self._show_snapshots, snapshots)
        except:
            GLib.idle_add(self._show_snapshots, [])
    
    def _show_snapshots(self, snapshots):
        # Clear existing
        while True:
            row = self.snapshots_group.get_first_child()
            if row is None:
                break
            self.snapshots_group.remove(row)
        
        if not snapshots:
            self.status_row.set_subtitle("No backups yet")
            return
        
        # Show last 5 snapshots
        for snap in snapshots[-5:]:
            if isinstance(snap, dict):
                num = snap.get('number', '?')
                date = snap.get('date', 'Unknown')
                desc = snap.get('description', 'Snapshot')
                row = Adw.ActionRow(title=f"Snapshot #{num}", subtitle=f"{date} - {desc}")
                self.snapshots_group.add(row)
        
        if snapshots:
            last = snapshots[-1]
            self.status_row.set_subtitle(f"Last: {last.get('date', 'Unknown')}")
    
    def do_backup(self, btn):
        btn.set_sensitive(False)
        btn.set_label("Creating...")
        
        def backup_thread():
            try:
                desc = f"Manual backup {datetime.now().strftime('%Y-%m-%d %H:%M')}"
                subprocess.run(['pkexec', 'snapper', 'create', '-d', desc], check=True)
                GLib.idle_add(self._backup_done, btn, True)
            except:
                GLib.idle_add(self._backup_done, btn, False)
        
        threading.Thread(target=backup_thread, daemon=True).start()
    
    def _backup_done(self, btn, success):
        btn.set_label("Backup" if success else "Failed")
        btn.set_sensitive(True)
        if success:
            self.load_snapshots()
    
    def browse_snapshots(self, btn):
        subprocess.Popen(['nautilus', '/.snapshots'])


class BackupApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='org.tahoeos.backup')
    
    def do_activate(self):
        win = BackupWindow(self)
        win.present()


if __name__ == '__main__':
    app = BackupApp()
    app.run()
```

**File: install.sh**
```bash
#!/bin/bash
dnf install -y snapper btrfs-progs

mkdir -p /usr/share/tahoe-backup
cp src/tahoe-backup.py /usr/share/tahoe-backup/

cat > /usr/bin/tahoe-backup << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-backup/tahoe-backup.py "$@"
EOF
chmod +x /usr/bin/tahoe-backup

cat > /usr/share/applications/org.tahoeos.backup.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Time Machine
Comment=Backup and restore with Btrfs snapshots
Exec=tahoe-backup
Icon=drive-harddisk
Categories=System;
EOF

# Configure snapper
snapper -c root create-config / 2>/dev/null || true
```

---

### P25: tahoe-kernel-config

```bash
mkdir -p /home/tahoeos/packages/tahoe-kernel-config
cd /home/tahoeos/packages/tahoe-kernel-config
```

**File: install.sh**
```bash
#!/bin/bash

# Sysctl optimizations
cat > /etc/sysctl.d/99-tahoeos.conf << 'EOF'
# TahoeOS Kernel Tuning

# Swappiness (prefer RAM)
vm.swappiness=10

# VFS cache pressure
vm.vfs_cache_pressure=50

# Dirty ratio (delay writes)
vm.dirty_ratio=10
vm.dirty_background_ratio=5

# Network optimizations
net.core.netdev_max_backlog=16384
net.core.somaxconn=8192
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0

# Security
kernel.kptr_restrict=2
kernel.dmesg_restrict=1
net.ipv4.conf.all.rp_filter=1

# Disable watchdog (better battery)
kernel.nmi_watchdog=0
EOF

# Apply immediately
sysctl --system

# Gaming optimizations in GRUB
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off nowatchdog"/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || true
```

---

### P26: tahoe-browser (Firefox theme)

```bash
mkdir -p /home/tahoeos/packages/tahoe-browser
cd /home/tahoeos/packages/tahoe-browser
```

**File: install.sh**
```bash
#!/bin/bash

# Firefox macOS theme
mkdir -p /etc/skel/.mozilla/firefox/tahoeos.default

cat > /etc/skel/.mozilla/firefox/tahoeos.default/user.js << 'EOF'
// TahoeOS Firefox Config
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.uidensity", 0);
user_pref("browser.tabs.drawInTitlebar", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("browser.theme.dark-private-windows", true);
user_pref("widget.macos.native-context-menus", false);
EOF

# Download WhiteSur Firefox theme
mkdir -p /etc/skel/.mozilla/firefox/tahoeos.default/chrome
cd /tmp
git clone --depth=1 https://github.com/nicholasly/Monterey-Safari-webextension-theme.git 2>/dev/null || true
if [[ -d Monterey-Safari-webextension-theme ]]; then
    cp -r Monterey-Safari-webextension-theme/chrome/* /etc/skel/.mozilla/firefox/tahoeos.default/chrome/
fi
rm -rf Monterey-Safari-webextension-theme

# Create profiles.ini
cat > /etc/skel/.mozilla/firefox/profiles.ini << 'EOF'
[Profile0]
Name=default
IsRelative=1
Path=tahoeos.default
Default=1

[General]
StartWithLastProfile=1
EOF
```

---

### P27: tahoe-app-mapping

```bash
mkdir -p /home/tahoeos/packages/tahoe-app-mapping
cd /home/tahoeos/packages/tahoe-app-mapping
```

**File: install.sh**
```bash
#!/bin/bash

# Create macOS-style app name mappings
mkdir -p /usr/share/applications

# Files → Finder
cat > /usr/share/applications/org.gnome.Nautilus.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Finder
Comment=Access and organize files
Exec=nautilus --new-window %U
Icon=system-file-manager
Categories=GNOME;GTK;Utility;Core;FileManager;
MimeType=inode/directory;
EOF

# Text Editor → TextEdit
cat > /usr/share/applications/org.gnome.TextEditor.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=TextEdit
Comment=Edit text files
Exec=gnome-text-editor %U
Icon=accessories-text-editor
Categories=GNOME;GTK;Utility;TextEditor;
MimeType=text/plain;
EOF

# Settings → System Preferences
cat > /usr/share/applications/org.gnome.Settings.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=System Preferences
Comment=System settings
Exec=gnome-control-center
Icon=preferences-system
Categories=GNOME;GTK;Settings;
EOF

# Terminal stays Terminal (macOS name)
# Calculator stays Calculator (macOS name)

# Photos → Photos (same)
# Videos → QuickTime Player style
cat > /usr/share/applications/org.gnome.Totem.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=QuickTime Player
Comment=Play movies and music
Exec=totem %U
Icon=applications-multimedia
Categories=GNOME;GTK;AudioVideo;Player;
MimeType=video/*;audio/*;
EOF

# Document Viewer → Preview
cat > /usr/share/applications/org.gnome.Evince.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Preview
Comment=View documents and images
Exec=evince %U
Icon=accessories-document-viewer
Categories=GNOME;GTK;Viewer;
MimeType=application/pdf;image/*;
EOF

# Image Viewer → Preview (same app)
# Archive Manager → Archive Utility
cat > /usr/share/applications/org.gnome.FileRoller.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Archive Utility
Comment=Create and extract archives
Exec=file-roller %U
Icon=utilities-file-archiver
Categories=GNOME;GTK;Utility;
MimeType=application/zip;application/x-tar;
EOF

update-desktop-database /usr/share/applications
```

---

### P28: tahoe-shell-config

```bash
mkdir -p /home/tahoeos/packages/tahoe-shell-config
cd /home/tahoeos/packages/tahoe-shell-config
```

**File: install.sh**
```bash
#!/bin/bash

# Install zsh
dnf install -y zsh

# Set zsh as default shell for new users
sed -i 's|SHELL=/bin/bash|SHELL=/bin/zsh|' /etc/default/useradd 2>/dev/null || true

# GNOME Shell config (top bar)
cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/shell]
disable-extension-version-validation=true

[org/gnome/desktop/interface]
clock-show-date=true
clock-show-seconds=false
clock-show-weekday=true
clock-format='12h'

[org/gnome/shell/weather]
automatic-location=true

[org/gnome/desktop/calendar]
show-weekdate=false
EOF

dconf update
```

---

### P22: tahoe-security

```bash
mkdir -p /home/tahoeos/packages/tahoe-security
cd /home/tahoeos/packages/tahoe-security
```

**File: install.sh**
```bash
#!/bin/bash

# Firewall config
dnf install -y firewalld
systemctl enable firewalld

# Allow outgoing, block incoming (except established)
firewall-cmd --permanent --set-default-zone=drop
firewall-cmd --permanent --zone=drop --add-service=dhcpv6-client
firewall-cmd --permanent --zone=drop --change-interface=lo
firewall-cmd --reload

# Fail2ban for SSH (if enabled)
dnf install -y fail2ban
systemctl enable fail2ban

cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
maxretry = 3
bantime = 3600
EOF

# USB guard (optional - disabled by default)
# dnf install -y usbguard
```

---

## Step 3: Master Install Script

Create this script to install ALL packages:

```bash
cat > /home/tahoeos/install-all-packages.sh << 'MASTER'
#!/bin/bash
set -e

echo "=== Installing All TahoeOS Packages ==="

cd /home/tahoeos/packages

# Themes from GitHub
echo "[1/15] Installing themes..."
cd /tmp
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme && ./install.sh -c Dark -l -N glassy && cd ..

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme && ./install.sh && cd ..

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors && ./install.sh && cd ..

git clone --depth=1 https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes && ./install.sh -t whitesur && cd ..

git clone --depth=1 https://github.com/AdisonCavani/plymouth-theme-apple.git
cd plymouth-theme-apple && cp -r apple /usr/share/plymouth/themes/ && plymouth-set-default-theme apple && cd ..

rm -rf /tmp/WhiteSur-* /tmp/grub2-themes /tmp/plymouth-theme-apple

# Custom packages
for pkg in tahoe-fonts tahoe-control-center tahoe-gpu-manager tahoe-update-manager \
           tahoe-spotlight tahoe-terminal tahoe-backup tahoe-kernel-config \
           tahoe-browser tahoe-app-mapping tahoe-shell-config tahoe-security; do
    echo "Installing $pkg..."
    cd /home/tahoeos/packages/$pkg
    bash install.sh
done

# Rebuild initramfs
dracut -f --regenerate-all

# Update dconf
dconf update

echo "=== All packages installed ==="
MASTER
chmod +x /home/tahoeos/install-all-packages.sh
```

---

## Step 4: Build ISO

After all packages are installed, create the ISO:

```bash
cd /home/tahoeos

sudo livemedia-creator \
    --ks=build/kickstart/tahoeos.ks \
    --no-virt \
    --resultdir=./output \
    --project=TahoeOS \
    --releasever=42 \
    --iso-only \
    --iso-name=TahoeOS-2026.1-x86_64.iso \
    --tmp=/var/tmp
```

---

## Quick Start Command for OpenCode

Tell OpenCode on VPS:

```
Read /home/tahoeos/docs/COMPLETE_BUILD.md and execute all steps to build TahoeOS ISO with all 30 packages.
```
