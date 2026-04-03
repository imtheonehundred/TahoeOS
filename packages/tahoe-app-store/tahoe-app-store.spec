Name:           tahoe-app-store
Version:        1.0.0
Release:        1%{?dist}
Summary:        TahoeOS App Store - Unified application manager
License:        MIT
URL:            https://github.com/tahoeos/tahoe-app-store

BuildArch:      noarch
Requires:       python3
Requires:       python3-gobject
Requires:       gtk4
Requires:       libadwaita
Requires:       flatpak
Requires:       dnf
Requires:       python3-requests

%description
Unified app store for TahoeOS that manages Linux packages (DNF),
Flatpaks, Windows applications (Wine/Bottles/Lutris), and AppImages
from a single beautiful interface.

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/tahoe-app-store
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/scalable/apps

cp -r src/* %{buildroot}%{_datadir}/tahoe-app-store/

cat > %{buildroot}%{_bindir}/tahoe-app-store << 'EOF'
#!/bin/bash
cd /usr/share/tahoe-app-store
exec python3 main.py "$@"
EOF
chmod +x %{buildroot}%{_bindir}/tahoe-app-store

cat > %{buildroot}%{_datadir}/applications/org.tahoeos.appstore.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=App Store
GenericName=Application Manager
Comment=Browse and install applications
Exec=tahoe-app-store
Icon=org.tahoeos.appstore
Categories=System;PackageManager;
Keywords=app;store;install;package;flatpak;wine;
StartupNotify=true
EOF

%files
%{_bindir}/tahoe-app-store
%{_datadir}/tahoe-app-store/
%{_datadir}/applications/org.tahoeos.appstore.desktop

%changelog
* Fri Apr 03 2026 TahoeOS Team <team@tahoeos.org> - 1.0.0-1
- Initial release
