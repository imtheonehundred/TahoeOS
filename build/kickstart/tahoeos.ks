#version=F42
# TahoeOS Kickstart - Full Branded ISO
# Fedora 42 + macOS Tahoe Theme + Gaming + Boot Branding

# Note: Do not set display mode (text/graphical) - livemedia-creator handles this
lang en_US.UTF-8
keyboard us
timezone UTC --utc

network --bootproto=dhcp --device=link --activate

rootpw --lock
user --name=tahoeos --groups=wheel --plaintext --password=tahoeos

firewall --enabled --service=ssh,mdns
selinux --enforcing
services --enabled=NetworkManager,bluetooth,cups,gdm

bootloader --location=mbr --timeout=5 --append="quiet splash plymouth.enable=1"

zerombr
clearpart --all --initlabel
part / --fstype=ext4 --size=12000

reboot

url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-42&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f42&arch=$basearch
repo --name=rpmfusion-free --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-42&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-42&arch=$basearch

%packages
@^workstation-product-environment

# GNOME
gnome-tweaks
gnome-extensions-app
gnome-shell-extension-dash-to-dock
gnome-shell-extension-appindicator

# Live ISO requirements
dracut-live
livesys-scripts

# Boot theming
plymouth
plymouth-theme-spinner
grub2-tools

# Multimedia
ffmpeg
gstreamer1-plugins-good
gstreamer1-plugins-bad-free
gstreamer1-plugins-ugly
gstreamer1-libav

# Gaming
steam
wine
winetricks
lutris
gamescope
mangohud
gamemode

# Vulkan
vulkan-loader
vulkan-tools
mesa-vulkan-drivers
mesa-dri-drivers

# System
flatpak
btrfs-progs
git
wget
unzip

# Theme building
sassc
gtk-murrine-engine

# Fonts
google-noto-sans-fonts
liberation-fonts

# Remove bloat
-libreoffice-*
-unoconv
-rhythmbox
-totem
-cheese
-gnome-tour
-gnome-boxes
-gnome-contacts
-gnome-maps
-gnome-weather
-gnome-clocks
-simple-scan
-mediawriter
%end

%post --log=/root/tahoeos-post.log --nochroot
echo "=== TahoeOS Post-Install ==="
echo "Started: $(date)"

# OS Branding
cat > /mnt/sysroot/etc/os-release << 'EOF'
NAME="TahoeOS"
VERSION="2026.1"
ID=tahoeos
ID_LIKE=fedora
VERSION_ID=2026.1
VERSION_CODENAME="Tahoe"
PRETTY_NAME="TahoeOS 2026.1 (Tahoe)"
ANSI_COLOR="0;38;2;0;122;255"
LOGO=tahoeos-logo
HOME_URL="https://tahoeos.org"
BUG_REPORT_URL="https://github.com/tahoeos/tahoeos/issues"
EOF

# GRUB Branding
sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="TahoeOS"/' /mnt/sysroot/etc/default/grub || true

# Desktop Settings
mkdir -p /mnt/sysroot/etc/dconf/db/local.d
mkdir -p /mnt/sysroot/etc/dconf/profile

cat > /mnt/sysroot/etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

cat > /mnt/sysroot/etc/dconf/db/local.d/00-tahoeos << 'EOF'
[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'steam.desktop', 'net.lutris.Lutris.desktop', 'org.gnome.Settings.desktop']

[org/gnome/desktop/interface]
color-scheme='prefer-dark'
enable-animations=true
clock-show-weekday=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'

[org/gnome/mutter]
center-new-windows=true
edge-tiling=true
dynamic-workspaces=true

[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true
natural-scroll=true
two-finger-scrolling-enabled=true

[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=true
EOF

# Create first-boot theme installer service
cat > /mnt/sysroot/usr/local/bin/tahoeos-first-boot.sh << 'EOFSCRIPT'
#!/bin/bash
set -e

LOG="/var/log/tahoeos-first-boot.log"
exec > >(tee -a "$LOG") 2>&1

echo "=== TahoeOS First Boot Setup ==="
echo "Started: $(date)"

# Install all themes (requires network)
cd /tmp

# GTK Theme
echo "[1/6] Installing GTK theme..."
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -c Dark -l -N glassy --tweaks macOS
mkdir -p /usr/share/themes
cp -r ~/.themes/WhiteSur-Dark /usr/share/themes/TahoeOS || true
cd /tmp
rm -rf WhiteSur-gtk-theme

# Icon Theme
echo "[2/6] Installing icon theme..."
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh
cd /tmp
rm -rf WhiteSur-icon-theme

# Cursor Theme
echo "[3/6] Installing cursor theme..."
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
./install.sh
cd /tmp
rm -rf WhiteSur-cursors

# GRUB Theme
echo "[4/6] Installing GRUB theme..."
git clone --depth=1 https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t whitesur -s 1080p
cd /tmp
rm -rf grub2-themes
grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || true
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 2>/dev/null || true

# Plymouth Theme
echo "[5/6] Installing Plymouth theme..."
git clone --depth=1 https://github.com/AdisonCavani/plymouth-theme-apple.git
cd plymouth-theme-apple
cp -r apple /usr/share/plymouth/themes/
plymouth-set-default-theme apple
cd /tmp
rm -rf plymouth-theme-apple
dracut -f 2>/dev/null || true

# Apply themes system-wide
echo "[6/6] Applying themes..."
mkdir -p /etc/dconf/db/gdm.d
cat > /etc/dconf/db/gdm.d/01-tahoeos << 'EOF'
[org/gnome/desktop/interface]
gtk-theme='WhiteSur-Dark'
icon-theme='WhiteSur-dark'
cursor-theme='WhiteSur-cursors'
EOF

sed -i "s/gtk-theme=.*/gtk-theme='WhiteSur-Dark'/" /etc/dconf/db/local.d/00-tahoeos || true
sed -i "s/icon-theme=.*/icon-theme='WhiteSur-dark'/" /etc/dconf/db/local.d/00-tahoeos || true
sed -i "s/cursor-theme=.*/cursor-theme='WhiteSur-cursors'/" /etc/dconf/db/local.d/00-tahoeos || true

dconf update

# Install Flatpak remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Disable this service after first run
systemctl disable tahoeos-first-boot.service

echo "=== TahoeOS First Boot Complete ==="
echo "Finished: $(date)"
echo "Please reboot to see all changes."
EOFSCRIPT

chmod +x /mnt/sysroot/usr/local/bin/tahoeos-first-boot.sh

# Create systemd service
cat > /mnt/sysroot/etc/systemd/system/tahoeos-first-boot.service << 'EOFSVC'
[Unit]
Description=TahoeOS First Boot Setup
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/tahoeos-first-boot.sh
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOFSVC

# Enable the service
chroot /mnt/sysroot systemctl enable tahoeos-first-boot.service

echo "=== TahoeOS Post-Install Complete ==="
echo "Finished: $(date)"

%end
