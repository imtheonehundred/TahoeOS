Name:           tahoe-wine-integration
Version:        1.0.0
Release:        1%{?dist}
Summary:        TahoeOS Wine Integration - Double-click Windows .exe support
License:        MIT
URL:            https://github.com/tahoeos/tahoe-wine-integration

BuildArch:      noarch
Requires:       python3
Requires:       python3-gobject
Requires:       gtk4
Requires:       libadwaita
Requires:       wine
Requires:       winetricks
Requires:       icoutils
Requires:       ImageMagick

%description
Enables double-click to install Windows .exe files on TahoeOS.
Automatically creates Wine prefixes, extracts icons, and generates
.desktop entries so Windows apps appear in the application grid.

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/tahoe-wine-integration
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/mime/packages

cp -r src/* %{buildroot}%{_datadir}/tahoe-wine-integration/

cat > %{buildroot}%{_bindir}/tahoe-wine-handler << 'EOF'
#!/bin/bash
cd /usr/share/tahoe-wine-integration
exec python3 tahoe-wine-handler.py "$@"
EOF
chmod +x %{buildroot}%{_bindir}/tahoe-wine-handler

cat > %{buildroot}%{_datadir}/applications/tahoe-wine-handler.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Windows Application Installer
GenericName=Wine Handler
Comment=Install Windows applications
Exec=tahoe-wine-handler %f
Icon=application-x-ms-dos-executable
MimeType=application/x-ms-dos-executable;application/x-msdos-program;
Categories=System;Wine;
NoDisplay=true
Terminal=false
EOF

cat > %{buildroot}%{_datadir}/mime/packages/tahoe-wine.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-ms-dos-executable">
    <comment>Windows Executable</comment>
    <glob pattern="*.exe"/>
  </mime-type>
</mime-info>
EOF

%post
update-mime-database %{_datadir}/mime &>/dev/null || :
update-desktop-database %{_datadir}/applications &>/dev/null || :
xdg-mime default tahoe-wine-handler.desktop application/x-ms-dos-executable &>/dev/null || :

%files
%{_bindir}/tahoe-wine-handler
%{_datadir}/tahoe-wine-integration/
%{_datadir}/applications/tahoe-wine-handler.desktop
%{_datadir}/mime/packages/tahoe-wine.xml

%changelog
* Fri Apr 03 2026 TahoeOS Team <team@tahoeos.org> - 1.0.0-1
- Initial release
