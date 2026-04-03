#!/bin/bash
set -e

mkdir -p /usr/share/gnome-shell/extensions/tahoe-lock-screen@tahoeos.org

cat > /usr/share/gnome-shell/extensions/tahoe-lock-screen@tahoeos.org/metadata.json << 'EOF'
{
    "uuid": "tahoe-lock-screen@tahoeos.org",
    "name": "TahoeOS Lock Screen",
    "description": "macOS-style lock screen",
    "shell-version": ["45", "46", "47"],
    "version": 1
}
EOF

cat > /usr/share/gnome-shell/extensions/tahoe-lock-screen@tahoeos.org/extension.js << 'EOF'
export default class TahoeLockScreen {
    enable() {}
    disable() {}
}
EOF

cat > /usr/share/gnome-shell/extensions/tahoe-lock-screen@tahoeos.org/stylesheet.css << 'EOF'
.unlock-dialog {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.unlock-dialog .login-dialog-user-selection-box {
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    padding: 24px;
}

.unlock-dialog .login-dialog-prompt-label {
    color: white;
    font-size: 14px;
}

.unlock-dialog StEntry {
    border-radius: 8px;
    background-color: rgba(255, 255, 255, 0.15);
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.2);
}

.unlock-dialog .login-dialog-button {
    background-color: #667eea;
    border-radius: 8px;
    color: white;
}

.unlock-dialog .login-dialog-button:hover {
    background-color: #764ba2;
}
EOF

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0
picture-uri='file:///usr/share/backgrounds/tahoeos/tahoe-dark.png'

[org/gnome/desktop/session]
idle-delay=uint32 300
EOF

dconf update

echo "tahoe-lock-screen installed"
