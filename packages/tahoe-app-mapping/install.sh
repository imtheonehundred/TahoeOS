#!/bin/bash
set -e

mkdir -p /usr/share/applications

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

cat > /usr/share/applications/org.gnome.Settings.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=System Preferences
Comment=System settings
Exec=gnome-control-center
Icon=preferences-system
Categories=GNOME;GTK;Settings;
EOF

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

update-desktop-database /usr/share/applications 2>/dev/null || true

echo "tahoe-app-mapping installed"
