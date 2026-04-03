#!/bin/bash
set -e

mkdir -p /usr/share/gnome-shell/extensions/tahoe-window-manager@tahoeos.org

cat > /usr/share/gnome-shell/extensions/tahoe-window-manager@tahoeos.org/metadata.json << 'EOF'
{
    "uuid": "tahoe-window-manager@tahoeos.org",
    "name": "TahoeOS Window Manager",
    "description": "Mission Control-style window management",
    "shell-version": ["45", "46", "47"],
    "version": 1
}
EOF

cat > /usr/share/gnome-shell/extensions/tahoe-window-manager@tahoeos.org/extension.js << 'EOF'
import Clutter from 'gi://Clutter';
import Meta from 'gi://Meta';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class TahoeWindowManager {
    enable() {
        this._settings = Main.wm._shellwm.get_settings();
        
        Main.wm.addKeybinding(
            'tahoe-expose',
            this._settings,
            Meta.KeyBindingFlags.NONE,
            Shell.ActionMode.NORMAL,
            () => Main.overview.toggle()
        );
    }
    
    disable() {
        Main.wm.removeKeybinding('tahoe-expose');
    }
}
EOF

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/desktop/wm/keybindings]
switch-applications=['<Super>Tab']
switch-windows=['<Alt>Tab']
show-desktop=['<Super>d']

[org/gnome/mutter]
edge-tiling=true
dynamic-workspaces=true
workspaces-only-on-primary=true
EOF

dconf update

echo "tahoe-window-manager installed"
