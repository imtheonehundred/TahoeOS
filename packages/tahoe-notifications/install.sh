#!/bin/bash
set -e

mkdir -p /usr/share/gnome-shell/extensions/tahoe-notifications@tahoeos.org

cat > /usr/share/gnome-shell/extensions/tahoe-notifications@tahoeos.org/metadata.json << 'EOF'
{
    "uuid": "tahoe-notifications@tahoeos.org",
    "name": "TahoeOS Notifications",
    "description": "macOS-style notification center",
    "shell-version": ["45", "46", "47"],
    "version": 1
}
EOF

cat > /usr/share/gnome-shell/extensions/tahoe-notifications@tahoeos.org/extension.js << 'EOF'
import St from 'gi://St';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class TahoeNotifications {
    enable() {
        this._originalAddNotification = Main.messageTray._addNotification;
        Main.messageTray._addNotification = function(notification) {
            this._originalAddNotification(notification);
        }.bind(Main.messageTray);
    }
    
    disable() {
        Main.messageTray._addNotification = this._originalAddNotification;
    }
}
EOF

cat > /usr/share/gnome-shell/extensions/tahoe-notifications@tahoeos.org/stylesheet.css << 'EOF'
.notification-banner {
    border-radius: 12px;
    margin: 8px;
    padding: 12px;
    background-color: rgba(40, 40, 40, 0.95);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
}

.notification-banner .notification-title {
    font-weight: bold;
    font-size: 13px;
}

.notification-banner .notification-body {
    font-size: 12px;
    color: #ccc;
}
EOF

echo "tahoe-notifications installed"
