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
grub2-pc
grub2-pc-modules
grub2-efi-x64

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

# Create EFI/BOOT directory for hybrid ISO creation
# Lorax/xorriso needs /EFI/BOOT in root filesystem for hybrid boot
mkdir -p /mnt/sysroot/EFI/BOOT

# Copy EFI bootloader files from installed packages
if [ -f /mnt/sysroot/usr/share/efi/x86_64/BOOTX64.EFI ]; then
    cp /mnt/sysroot/usr/share/efi/x86_64/BOOTX64.EFI /mnt/sysroot/EFI/BOOT/ 2>/dev/null || true
fi
if [ -f /mnt/sysroot/usr/share/efi/x86_64/GRUBX64.EFI ]; then
    cp /mnt/sysroot/usr/share/efi/x86_64/GRUBX64.EFI /mnt/sysroot/EFI/BOOT/ 2>/dev/null || true
fi

# Alternative locations for EFI files
for dir in /mnt/sysroot/usr/lib/grub/x86_64-efi /mnt/sysroot/usr/share/grub/efi; do
    if [ -d "$dir" ]; then
        find "$dir" -name "*.efi" -exec cp {} /mnt/sysroot/EFI/BOOT/ \; 2>/dev/null || true
    fi
done

# If shim is installed, copy shimx64.efi as bootx64.efi
if [ -f /mnt/sysroot/usr/share/efi/shimx64.efi ]; then
    cp /mnt/sysroot/usr/share/efi/shimx64.efi /mnt/sysroot/EFI/BOOT/BOOTX64.EFI 2>/dev/null || true
fi
if [ -f /mnt/sysroot/usr/share/efi/grubx64.efi ]; then
    cp /mnt/sysroot/usr/share/efi/grubx64.efi /mnt/sysroot/EFI/BOOT/GRUBX64.EFI 2>/dev/null || true
fi

ls -la /mnt/sysroot/EFI/BOOT/ 2>/dev/null || echo "EFI/BOOT not populated"

# Copy themes from repo to installed system
if [ -d "/__w/TahoeOS/TahoeOS/build/themes-bundle" ]; then
    echo "Copying pre-downloaded themes to installed system..."
    cp -r /__w/TahoeOS/TahoeOS/build/themes-bundle /mnt/sysroot/tmp/
fi

%end

%post --log=/root/tahoeos-post-themes.log
echo "=== Installing Themes ==="

# Check if themes were copied
if [ -d /tmp/themes-bundle ]; then
    cd /tmp/themes-bundle
    
    # Install GTK Theme (MacTahoe - macOS Sequoia/Tahoe style)
    echo "Installing MacTahoe GTK theme..."
    cd MacTahoe-gtk-theme
    ./install.sh -c Dark -l -b --darker -d /usr/share/themes
    cd ..
    
    # Install Icon Theme (MacTahoe)
    echo "Installing MacTahoe icon theme..."
    cd MacTahoe-icon-theme
    ./install.sh -d /usr/share/icons
    cd ..
    
    # Install Cursor Theme
    echo "Installing cursor theme..."
    cd WhiteSur-cursors
    ./install.sh -d /usr/share/icons
    cd ..
    
    # Install GRUB Theme
    echo "Installing GRUB theme..."
    cd grub2-themes
    ./install.sh -t whitesur -s 1080p
    grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || true
    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 2>/dev/null || true
    cd ..
    
    # Install Plymouth Theme
    echo "Installing Plymouth theme..."
    cd plymouth-themes
    # Use minimal macOS-style spinner theme
    mkdir -p /usr/share/plymouth/themes/tahoeos-spinner
    cp -r pack_1/sphere/spinner/* /usr/share/plymouth/themes/tahoeos-spinner/ 2>/dev/null || \
    cp -r pack_1/cuts/cuts/* /usr/share/plymouth/themes/tahoeos-spinner/ 2>/dev/null || true
    
    # If no theme copied, create a simple one
    if [ ! -f /usr/share/plymouth/themes/tahoeos-spinner/spinner.plymouth ]; then
        cat > /usr/share/plymouth/themes/tahoeos-spinner/tahoeos-spinner.plymouth << 'PLYM'
[Plymouth Theme]
Name=TahoeOS Spinner
Description=Simple macOS-style boot theme
ModuleName=two-step

[two-step]
Font=Inter 12
TitleFont=Inter Light 24
ImageDir=/usr/share/plymouth/themes/tahoeos-spinner
DialogHorizontalAlignment=.5
DialogVerticalAlignment=.382
TitleHorizontalAlignment=.5
TitleVerticalAlignment=.382
HorizontalAlignment=.5
VerticalAlignment=.7
WatermarkHorizontalAlignment=.5
WatermarkVerticalAlignment=.96
Transition=none
TransitionDuration=0.0
BackgroundStartColor=0x000000
BackgroundEndColor=0x000000
ProgressBarBackgroundColor=0x606060
ProgressBarForegroundColor=0x0066cc
PLYM
    fi
    
    plymouth-set-default-theme tahoeos-spinner
    dracut -f 2>/dev/null || true
    cd ..
    
    # Cleanup
    cd /
    rm -rf /tmp/themes-bundle
    
    echo "All themes installed successfully"
else
    echo "WARNING: Themes bundle not found, using defaults"
fi

# Desktop Settings
mkdir -p /etc/dconf/db/local.d
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/gdm.d

cat > /etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

# GDM Settings
cat > /etc/dconf/db/gdm.d/01-tahoeos << 'EOF'
[org/gnome/desktop/interface]
gtk-theme='MacTahoe-Dark'
icon-theme='MacTahoe'
cursor-theme='WhiteSur-cursors'
EOF

# User Desktop Settings
cat > /etc/dconf/db/local.d/00-tahoeos << 'EOF'
[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'steam.desktop', 'net.lutris.Lutris.desktop', 'org.gnome.Settings.desktop']

[org/gnome/desktop/interface]
gtk-theme='MacTahoe-Dark'
icon-theme='MacTahoe'
cursor-theme='WhiteSur-cursors'
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

[org/gnome/desktop/sound]
theme-name='freedesktop'
event-sounds=true
input-feedback-sounds=true
EOF

dconf update

echo "=== TahoeOS Post-Install Complete ==="
echo "Finished: $(date)"

%end
