#!/bin/bash
set -e

mkdir -p /etc/skel/.mozilla/firefox/tahoeos.default/chrome

cat > /etc/skel/.mozilla/firefox/tahoeos.default/user.js << 'EOF'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.uidensity", 0);
user_pref("browser.tabs.drawInTitlebar", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("browser.theme.dark-private-windows", true);
user_pref("browser.compactmode.show", true);
EOF

cat > /etc/skel/.mozilla/firefox/tahoeos.default/chrome/userChrome.css << 'EOF'
:root {
    --tab-border-radius: 8px;
    --toolbar-bgcolor: rgba(30, 30, 30, 0.95) !important;
}

#TabsToolbar {
    background: transparent !important;
}

.tab-background {
    border-radius: var(--tab-border-radius) var(--tab-border-radius) 0 0 !important;
    margin-top: 4px !important;
}

.tab-background[selected] {
    background: var(--toolbar-bgcolor) !important;
}

#nav-bar {
    background: var(--toolbar-bgcolor) !important;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1) !important;
}

#urlbar-background {
    border-radius: 8px !important;
    background: rgba(255, 255, 255, 0.1) !important;
}
EOF

cat > /etc/skel/.mozilla/firefox/profiles.ini << 'EOF'
[Profile0]
Name=default
IsRelative=1
Path=tahoeos.default
Default=1

[General]
StartWithLastProfile=1
EOF

echo "tahoe-browser installed"
