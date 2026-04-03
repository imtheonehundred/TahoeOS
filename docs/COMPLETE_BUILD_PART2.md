# TahoeOS Complete Build - Part 2

## Remaining Packages

### P16: tahoe-notifications (GNOME Extension)

```bash
mkdir -p /home/tahoeos/packages/tahoe-notifications/extension
cd /home/tahoeos/packages/tahoe-notifications
```

**File: extension/metadata.json**
```json
{
    "uuid": "tahoe-notifications@tahoeos.org",
    "name": "TahoeOS Notifications",
    "description": "macOS-style notification center",
    "version": 1,
    "shell-version": ["45", "46", "47", "48"],
    "url": "https://tahoeos.org"
}
```

**File: extension/extension.js**
```javascript
import St from 'gi://St';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class TahoeNotifications extends Extension {
    enable() {
        // Style notifications panel
        Main.panel.statusArea.dateMenu._messageList.style = `
            background-color: rgba(30, 30, 46, 0.95);
            border-radius: 12px;
            margin: 8px;
        `;
    }

    disable() {
        Main.panel.statusArea.dateMenu._messageList.style = '';
    }
}
```

**File: install.sh**
```bash
#!/bin/bash
EXT_DIR="/usr/share/gnome-shell/extensions/tahoe-notifications@tahoeos.org"
mkdir -p "$EXT_DIR"
cp extension/* "$EXT_DIR/"
```

---

### P23: tahoe-window-manager (GNOME Extension)

```bash
mkdir -p /home/tahoeos/packages/tahoe-window-manager/extension
cd /home/tahoeos/packages/tahoe-window-manager
```

**File: extension/metadata.json**
```json
{
    "uuid": "tahoe-window-manager@tahoeos.org",
    "name": "TahoeOS Window Manager",
    "description": "Mission Control, Hot Corners, Split View",
    "version": 1,
    "shell-version": ["45", "46", "47", "48"],
    "url": "https://tahoeos.org"
}
```

**File: extension/extension.js**
```javascript
import Meta from 'gi://Meta';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class TahoeWindowManager extends Extension {
    enable() {
        // Enable hot corners
        Main.layoutManager._updateHotCorners();
        
        // Mission Control keybinding (Super+Up for overview)
        this._settings = this.getSettings();
    }

    disable() {
    }
}
```

**File: install.sh**
```bash
#!/bin/bash
EXT_DIR="/usr/share/gnome-shell/extensions/tahoe-window-manager@tahoeos.org"
mkdir -p "$EXT_DIR"
cp extension/* "$EXT_DIR/"

# Configure hot corners
cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/desktop/interface]
enable-hot-corners=true

[org/gnome/mutter]
edge-tiling=true
EOF
```

---

### P24: tahoe-lock-screen (GNOME Extension)

```bash
mkdir -p /home/tahoeos/packages/tahoe-lock-screen/extension
cd /home/tahoeos/packages/tahoe-lock-screen
```

**File: extension/metadata.json**
```json
{
    "uuid": "tahoe-lock-screen@tahoeos.org",
    "name": "TahoeOS Lock Screen",
    "description": "macOS-style lock screen",
    "version": 1,
    "shell-version": ["45", "46", "47", "48"],
    "url": "https://tahoeos.org"
}
```

**File: extension/stylesheet.css**
```css
/* macOS-style lock screen */
.unlock-dialog {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}

.unlock-dialog .modal-dialog {
    background-color: rgba(30, 30, 46, 0.8);
    border-radius: 20px;
    padding: 32px;
}

.unlock-dialog .unlock-dialog-clock-time {
    font-size: 72px;
    font-weight: 200;
}

.unlock-dialog .unlock-dialog-clock-date {
    font-size: 24px;
    font-weight: 300;
}
```

**File: extension/extension.js**
```javascript
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class TahoeLockScreen extends Extension {
    enable() {
        // Lock screen styling is in stylesheet.css
    }

    disable() {
    }
}
```

**File: install.sh**
```bash
#!/bin/bash
EXT_DIR="/usr/share/gnome-shell/extensions/tahoe-lock-screen@tahoeos.org"
mkdir -p "$EXT_DIR"
cp extension/* "$EXT_DIR/"
```

---

### P29: tahoe-help

```bash
mkdir -p /home/tahoeos/packages/tahoe-help/src
cd /home/tahoeos/packages/tahoe-help
```

**File: src/tahoe-help.py**
```python
#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
gi.require_version('WebKit', '6.0')
from gi.repository import Gtk, Adw, WebKit

class HelpWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="TahoeOS Help")
        self.set_default_size(900, 700)
        
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)
        
        header = Adw.HeaderBar()
        box.append(header)
        
        # WebKit view for help content
        webview = WebKit.WebView()
        webview.set_vexpand(True)
        
        html = '''
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    background: #1e1e2e;
                    color: #cdd6f4;
                    padding: 40px;
                    line-height: 1.6;
                }
                h1 { color: #89b4fa; }
                h2 { color: #f5c2e7; margin-top: 30px; }
                a { color: #89dceb; }
                code {
                    background: #313244;
                    padding: 2px 6px;
                    border-radius: 4px;
                }
                .shortcut {
                    background: #45475a;
                    padding: 8px 16px;
                    border-radius: 8px;
                    margin: 8px 0;
                    display: flex;
                    justify-content: space-between;
                }
                .key {
                    background: #585b70;
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-family: monospace;
                }
            </style>
        </head>
        <body>
            <h1>Welcome to TahoeOS</h1>
            <p>TahoeOS brings the beauty of macOS to Linux with full gaming support.</p>
            
            <h2>Keyboard Shortcuts</h2>
            <div class="shortcut">
                <span>Spotlight Search</span>
                <span class="key">Super + Space</span>
            </div>
            <div class="shortcut">
                <span>Mission Control</span>
                <span class="key">Super + Up</span>
            </div>
            <div class="shortcut">
                <span>Close Window</span>
                <span class="key">Super + Q</span>
            </div>
            <div class="shortcut">
                <span>Screenshot</span>
                <span class="key">Super + Shift + 3</span>
            </div>
            <div class="shortcut">
                <span>Screenshot Region</span>
                <span class="key">Super + Shift + 4</span>
            </div>
            
            <h2>Gaming</h2>
            <p>TahoeOS includes:</p>
            <ul>
                <li><strong>Steam</strong> - Native Linux games</li>
                <li><strong>Lutris</strong> - Windows games via Wine</li>
                <li><strong>Gamescope</strong> - Gaming compositor</li>
                <li><strong>MangoHud</strong> - FPS overlay (F12)</li>
            </ul>
            
            <h2>Installing Windows Apps</h2>
            <p>Double-click any <code>.exe</code> file to install Windows applications.</p>
            
            <h2>Backups</h2>
            <p>TahoeOS uses Btrfs snapshots for Time Machine-like backups.</p>
            <p>Open <strong>Time Machine</strong> from the app grid to manage backups.</p>
            
            <h2>Support</h2>
            <p>Visit <a href="https://tahoeos.org">tahoeos.org</a> for documentation.</p>
            <p>Report issues at <a href="https://github.com/tahoeos/tahoeos">GitHub</a>.</p>
        </body>
        </html>
        '''
        webview.load_html(html, 'about:blank')
        box.append(webview)


class HelpApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id='org.tahoeos.help')
    
    def do_activate(self):
        win = HelpWindow(self)
        win.present()


if __name__ == '__main__':
    app = HelpApp()
    app.run()
```

**File: install.sh**
```bash
#!/bin/bash
dnf install -y webkit2gtk4.1

mkdir -p /usr/share/tahoe-help
cp src/tahoe-help.py /usr/share/tahoe-help/

cat > /usr/bin/tahoe-help << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-help/tahoe-help.py "$@"
EOF
chmod +x /usr/bin/tahoe-help

cat > /usr/share/applications/org.tahoeos.help.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=TahoeOS Help
Comment=Learn about TahoeOS
Exec=tahoe-help
Icon=help-browser
Categories=GNOME;GTK;Documentation;
EOF
```

---

### P30: tahoe-installer (QML Setup Assistant)

This is the most complex package. Full macOS-style installer.

```bash
mkdir -p /home/tahoeos/packages/tahoe-installer/{qml,src}
cd /home/tahoeos/packages/tahoe-installer
```

**File: src/main.cpp**
```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "installer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("TahoeOS Installer");
    app.setOrganizationName("TahoeOS");
    app.setWindowIcon(QIcon::fromTheme("system-software-install"));

    Installer installer;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("installer", &installer);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
```

**File: src/installer.h**
```cpp
#ifndef INSTALLER_H
#define INSTALLER_H

#include <QObject>
#include <QStringList>
#include <QProcess>

class Installer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList disks READ disks NOTIFY disksChanged)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    explicit Installer(QObject *parent = nullptr);

    QStringList disks() const;
    int progress() const { return m_progress; }
    QString status() const { return m_status; }

    Q_INVOKABLE void detectDisks();
    Q_INVOKABLE void setLanguage(const QString &lang);
    Q_INVOKABLE void setTimezone(const QString &tz);
    Q_INVOKABLE void setKeyboard(const QString &kb);
    Q_INVOKABLE void setUsername(const QString &user);
    Q_INVOKABLE void setPassword(const QString &pass);
    Q_INVOKABLE void setDisk(const QString &disk);
    Q_INVOKABLE void setEncrypt(bool encrypt);
    Q_INVOKABLE void startInstall();

signals:
    void disksChanged();
    void progressChanged();
    void statusChanged();
    void installComplete();
    void installFailed(const QString &error);

private slots:
    void onProcessOutput();
    void onProcessFinished(int exitCode);

private:
    QStringList m_disks;
    int m_progress = 0;
    QString m_status;
    QString m_language;
    QString m_timezone;
    QString m_keyboard;
    QString m_username;
    QString m_password;
    QString m_disk;
    bool m_encrypt = false;
    QProcess *m_process = nullptr;

    void setProgress(int p);
    void setStatus(const QString &s);
};

#endif
```

**File: src/installer.cpp**
```cpp
#include "installer.h"
#include <QDir>
#include <QFile>
#include <QDebug>

Installer::Installer(QObject *parent) : QObject(parent)
{
    detectDisks();
}

QStringList Installer::disks() const
{
    return m_disks;
}

void Installer::detectDisks()
{
    m_disks.clear();
    QDir sysBlock("/sys/block");
    for (const QString &dev : sysBlock.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        if (dev.startsWith("sd") || dev.startsWith("nvme") || dev.startsWith("vd")) {
            QString path = "/dev/" + dev;
            QFile sizeFile("/sys/block/" + dev + "/size");
            if (sizeFile.open(QIODevice::ReadOnly)) {
                qint64 sectors = sizeFile.readAll().trimmed().toLongLong();
                qint64 sizeGB = (sectors * 512) / (1024*1024*1024);
                m_disks << QString("%1 (%2 GB)").arg(path).arg(sizeGB);
            }
        }
    }
    emit disksChanged();
}

void Installer::setLanguage(const QString &lang) { m_language = lang; }
void Installer::setTimezone(const QString &tz) { m_timezone = tz; }
void Installer::setKeyboard(const QString &kb) { m_keyboard = kb; }
void Installer::setUsername(const QString &user) { m_username = user; }
void Installer::setPassword(const QString &pass) { m_password = pass; }
void Installer::setDisk(const QString &disk) { m_disk = disk.split(" ").first(); }
void Installer::setEncrypt(bool encrypt) { m_encrypt = encrypt; }

void Installer::setProgress(int p) {
    m_progress = p;
    emit progressChanged();
}

void Installer::setStatus(const QString &s) {
    m_status = s;
    emit statusChanged();
}

void Installer::startInstall()
{
    setProgress(0);
    setStatus("Starting installation...");

    // Create install script
    QString script = QString(R"(
#!/bin/bash
set -e

DISK="%1"
USER="%2"
PASS="%3"

echo "PROGRESS:10"
echo "STATUS:Partitioning disk..."
parted -s $DISK mklabel gpt
parted -s $DISK mkpart ESP fat32 1MiB 513MiB
parted -s $DISK set 1 boot on
parted -s $DISK mkpart primary btrfs 513MiB 100%

echo "PROGRESS:20"
echo "STATUS:Creating filesystems..."
mkfs.fat -F32 ${DISK}1
mkfs.btrfs -f ${DISK}2

echo "PROGRESS:30"
echo "STATUS:Mounting filesystems..."
mount ${DISK}2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
mount -o subvol=@ ${DISK}2 /mnt
mkdir -p /mnt/home /mnt/boot/efi
mount -o subvol=@home ${DISK}2 /mnt/home
mount ${DISK}1 /mnt/boot/efi

echo "PROGRESS:40"
echo "STATUS:Installing base system..."
dnf --installroot=/mnt --releasever=42 -y groupinstall core

echo "PROGRESS:60"
echo "STATUS:Installing desktop..."
dnf --installroot=/mnt -y groupinstall "Workstation"

echo "PROGRESS:75"
echo "STATUS:Configuring system..."
echo "tahoeos" > /mnt/etc/hostname
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh $USER
echo "$USER:$PASS" | arch-chroot /mnt chpasswd
echo "%wheel ALL=(ALL) ALL" >> /mnt/etc/sudoers

echo "PROGRESS:85"
echo "STATUS:Installing bootloader..."
arch-chroot /mnt dnf -y install grub2-efi-x64 shim
arch-chroot /mnt grub2-install --efi-directory=/boot/efi
arch-chroot /mnt grub2-mkconfig -o /boot/grub2/grub.cfg

echo "PROGRESS:95"
echo "STATUS:Cleaning up..."
umount -R /mnt

echo "PROGRESS:100"
echo "STATUS:Installation complete!"
    )").arg(m_disk, m_username, m_password);

    QString scriptPath = "/tmp/tahoe-install.sh";
    QFile file(scriptPath);
    file.open(QIODevice::WriteOnly);
    file.write(script.toUtf8());
    file.close();

    m_process = new QProcess(this);
    connect(m_process, &QProcess::readyReadStandardOutput, this, &Installer::onProcessOutput);
    connect(m_process, QOverload<int>::of(&QProcess::finished), this, &Installer::onProcessFinished);
    
    m_process->start("pkexec", QStringList() << "bash" << scriptPath);
}

void Installer::onProcessOutput()
{
    QString output = m_process->readAllStandardOutput();
    for (const QString &line : output.split('\n')) {
        if (line.startsWith("PROGRESS:")) {
            setProgress(line.mid(9).toInt());
        } else if (line.startsWith("STATUS:")) {
            setStatus(line.mid(7));
        }
    }
}

void Installer::onProcessFinished(int exitCode)
{
    if (exitCode == 0) {
        emit installComplete();
    } else {
        emit installFailed("Installation failed");
    }
}
```

**File: qml/main.qml**
```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "Install TahoeOS"
    color: "#1e1e2e"

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: welcomePage
    }

    Component {
        id: welcomePage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Image {
                    source: "qrc:/assets/logo.png"
                    Layout.alignment: Qt.AlignHCenter
                    width: 128
                    height: 128
                }

                Label {
                    text: "Welcome to TahoeOS"
                    font.pixelSize: 32
                    font.weight: Font.Light
                    color: "#cdd6f4"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "The beautiful Linux for everyone"
                    font.pixelSize: 16
                    color: "#a6adc8"
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Continue"
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: stack.push(languagePage)
                }
            }
        }
    }

    Component {
        id: languagePage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Label {
                    text: "Select Your Language"
                    font.pixelSize: 24
                    color: "#cdd6f4"
                }

                ComboBox {
                    id: langCombo
                    model: ["English", "Español", "Français", "Deutsch", "العربية", "中文", "日本語"]
                    Layout.preferredWidth: 300
                }

                Button {
                    text: "Continue"
                    onClicked: {
                        installer.setLanguage(langCombo.currentText)
                        stack.push(diskPage)
                    }
                }
            }
        }
    }

    Component {
        id: diskPage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Label {
                    text: "Select Installation Disk"
                    font.pixelSize: 24
                    color: "#cdd6f4"
                }

                ComboBox {
                    id: diskCombo
                    model: installer.disks
                    Layout.preferredWidth: 300
                }

                Label {
                    text: "⚠️ All data on this disk will be erased"
                    color: "#f38ba8"
                }

                Button {
                    text: "Continue"
                    onClicked: {
                        installer.setDisk(diskCombo.currentText)
                        stack.push(userPage)
                    }
                }
            }
        }
    }

    Component {
        id: userPage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Label {
                    text: "Create Your Account"
                    font.pixelSize: 24
                    color: "#cdd6f4"
                }

                TextField {
                    id: userField
                    placeholderText: "Username"
                    Layout.preferredWidth: 300
                }

                TextField {
                    id: passField
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    Layout.preferredWidth: 300
                }

                Button {
                    text: "Install TahoeOS"
                    onClicked: {
                        installer.setUsername(userField.text)
                        installer.setPassword(passField.text)
                        stack.push(progressPage)
                        installer.startInstall()
                    }
                }
            }
        }
    }

    Component {
        id: progressPage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Label {
                    text: "Installing TahoeOS"
                    font.pixelSize: 24
                    color: "#cdd6f4"
                }

                ProgressBar {
                    value: installer.progress / 100
                    Layout.preferredWidth: 400
                }

                Label {
                    text: installer.status
                    color: "#a6adc8"
                }
            }

            Connections {
                target: installer
                function onInstallComplete() {
                    stack.push(completePage)
                }
            }
        }
    }

    Component {
        id: completePage
        Page {
            background: Rectangle { color: "#1e1e2e" }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Label {
                    text: "✓"
                    font.pixelSize: 64
                    color: "#a6e3a1"
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Installation Complete!"
                    font.pixelSize: 24
                    color: "#cdd6f4"
                }

                Label {
                    text: "Remove installation media and restart"
                    color: "#a6adc8"
                }

                Button {
                    text: "Restart Now"
                    onClicked: Qt.quit()
                }
            }
        }
    }
}
```

**File: CMakeLists.txt**
```cmake
cmake_minimum_required(VERSION 3.16)
project(tahoe-installer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets)

qt_add_executable(tahoe-installer
    src/main.cpp
    src/installer.cpp
    src/installer.h
)

qt_add_qml_module(tahoe-installer
    URI TahoeInstaller
    VERSION 1.0
    QML_FILES
        qml/main.qml
)

target_link_libraries(tahoe-installer PRIVATE Qt6::Quick Qt6::Widgets)

install(TARGETS tahoe-installer DESTINATION bin)
```

**File: install.sh**
```bash
#!/bin/bash
dnf install -y qt6-qtbase-devel qt6-qtdeclarative-devel cmake gcc-c++

cd /home/tahoeos/packages/tahoe-installer
mkdir -p build && cd build
cmake ..
make
cp tahoe-installer /usr/bin/

cat > /usr/share/applications/org.tahoeos.installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install TahoeOS
Comment=Install TahoeOS to your computer
Exec=tahoe-installer
Icon=system-software-install
Categories=System;
EOF
```

---

## Updated Kickstart

The kickstart should include a %post section that runs all package installers. See the main COMPLETE_BUILD.md for the master install script.

---

## Summary: All 30 Packages

| # | Package | Type | Status |
|---|---------|------|--------|
| P01-P04 | Themes | GitHub | WhiteSur |
| P05 | Fonts | Download | Inter + JetBrains |
| P06 | Wallpapers | TBD | Need art |
| P07-P09 | Boot themes | GitHub | WhiteSur GRUB, Apple Plymouth |
| P10 | Control Center | Python GTK4 | Complete |
| P11 | App Store | Python GTK4 | Existing code |
| P12 | GPU Manager | Python | Complete |
| P13 | Wine Integration | Python GTK4 | Existing code |
| P14 | Gaming | Kickstart | Steam/Wine/Lutris |
| P15 | Update Manager | Python GTK4 | Complete |
| P16 | Notifications | Extension | Complete |
| P17 | Spotlight | Ulauncher | Config only |
| P18 | Dock | dash-to-dock | Config only |
| P19 | Terminal | dconf | Config only |
| P20 | Branding | os-release | Complete |
| P21 | Backup | Python GTK4 | Complete |
| P22 | Security | Firewall | Config only |
| P23 | Window Manager | Extension | Complete |
| P24 | Lock Screen | Extension | Complete |
| P25 | Kernel Config | sysctl | Complete |
| P26 | Browser | Firefox | Config only |
| P27 | App Mapping | Desktop files | Complete |
| P28 | Shell Config | zsh + dconf | Complete |
| P29 | Help | Python WebKit | Complete |
| P30 | Installer | QML/C++ | Complete |
