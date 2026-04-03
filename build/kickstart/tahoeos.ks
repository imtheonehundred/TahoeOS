#version=F42
# TahoeOS Kickstart - Full Branded ISO
# Fedora 42 + macOS Tahoe Theme + Gaming + Boot Branding

text
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
autopart --type=btrfs

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
vlc
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

%post --log=/root/tahoeos-post.log --erroronfail

set -ex
exec > >(tee -a /root/tahoeos-post.log) 2>&1

echo "=== TahoeOS Post-Install ==="
echo "Started: $(date)"

#######################################
# 1. OS BRANDING
#######################################
echo "[1/7] Applying OS branding..."

cat > /etc/os-release << 'EOF'
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

#######################################
# 2. GRUB THEME (macOS style)
#######################################
echo "[2/7] Installing GRUB theme..."

cd /tmp
git clone --depth=1 https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
./install.sh -t whitesur -s 1080p
cd /tmp
rm -rf grub2-themes

# Update GRUB config
sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="TahoeOS"/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || true
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 2>/dev/null || true

#######################################
# 3. PLYMOUTH THEME (macOS style boot)
#######################################
echo "[3/7] Installing Plymouth theme..."

cd /tmp
git clone --depth=1 https://github.com/AdisonCavani/plymouth-theme-apple.git
cd plymouth-theme-apple
cp -r apple /usr/share/plymouth/themes/
plymouth-set-default-theme -R apple 2>/dev/null || plymouth-set-default-theme apple
cd /tmp
rm -rf plymouth-theme-apple

# Rebuild initramfs with new plymouth theme
dracut -f --regenerate-all 2>/dev/null || true

#######################################
# 4. GTK/ICON/CURSOR THEMES
#######################################
echo "[4/7] Installing desktop themes..."

cd /tmp

# GTK Theme
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh -c Dark -l -N glassy
cd /tmp
rm -rf WhiteSur-gtk-theme

# Icon Theme  
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh
cd /tmp
rm -rf WhiteSur-icon-theme

# Cursor Theme
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
./install.sh
cd /tmp
rm -rf WhiteSur-cursors

#######################################
# 5. GDM (Login Screen) THEME
#######################################
echo "[5/7] Configuring GDM..."

mkdir -p /etc/dconf/db/gdm.d

cat > /etc/dconf/db/gdm.d/01-tahoeos << 'EOF'
[org/gnome/login-screen]
banner-message-enable=false
disable-user-list=false

[org/gnome/desktop/interface]
gtk-theme='WhiteSur-Dark'
icon-theme='WhiteSur-dark'
cursor-theme='WhiteSur-cursors'
EOF

#######################################
# 6. DESKTOP SETTINGS
#######################################
echo "[6/7] Configuring desktop..."

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

mkdir -p /etc/dconf/db/local.d
mkdir -p /etc/dconf/profile

cat > /etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

cat > /etc/dconf/db/local.d/00-tahoeos << 'EOF'
[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'steam.desktop', 'net.lutris.Lutris.desktop', 'org.gnome.Settings.desktop']
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com']

[org/gnome/desktop/interface]
gtk-theme='WhiteSur-Dark'
icon-theme='WhiteSur-dark'
cursor-theme='WhiteSur-cursors'
color-scheme='prefer-dark'
enable-animations=true
clock-show-weekday=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
theme='WhiteSur-Dark'

[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
dock-fixed=true
extend-height=false
dash-max-icon-size=48
background-opacity=0.6
transparency-mode='FIXED'
show-apps-at-top=true
show-trash=false
show-mounts=false
click-action='minimize-or-previews'
running-indicator-style='DOTS'

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

dconf update

#######################################
# 7. GAMING CONFIG
#######################################
echo "[7/7] Configuring gaming..."

mkdir -p /etc/gamemode.d
cat > /etc/gamemode.d/tahoeos.ini << 'EOF'
[general]
renice=10
ioprio=0
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
amd_performance_level=high
EOF

mkdir -p /etc/MangoHud
cat > /etc/MangoHud/MangoHud.conf << 'EOF'
fps
frametime
cpu_stats
gpu_stats
ram
vram
font_size=20
position=top-left
toggle_hud=F12
EOF

#######################################
# CLEANUP
#######################################
echo "Cleaning up..."
dnf clean all
rm -rf /var/cache/dnf/*
rm -rf /tmp/*

echo "=== TahoeOS Post-Install Complete ==="
echo "Finished: $(date)"

%end
