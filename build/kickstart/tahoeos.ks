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
# Note: Network not available in anaconda %post, themes will be installed on first boot

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

echo "=== TahoeOS Post-Install Complete ==="
echo "Finished: $(date)"

%end
