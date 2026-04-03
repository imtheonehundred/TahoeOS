#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib, Gio
import subprocess
import os
import sys
import json
import tempfile
import shutil
from pathlib import Path

from prefix_manager import PrefixManager
from icon_extractor import IconExtractor
from desktop_generator import DesktopGenerator


class WineHandler:
    def __init__(self):
        self.config_dir = Path.home() / ".config" / "tahoe-wine"
        self.config_dir.mkdir(parents=True, exist_ok=True)
        self.prefixes_dir = (
            Path.home() / ".local" / "share" / "tahoeos" / "wine-prefixes"
        )
        self.prefixes_dir.mkdir(parents=True, exist_ok=True)
        self.apps_registry = self.config_dir / "apps.json"

        self.prefix_manager = PrefixManager(self.prefixes_dir)
        self.icon_extractor = IconExtractor()
        self.desktop_generator = DesktopGenerator()

        self.load_config()

    def load_config(self):
        self.config = {
            "default_prefix": "default",
            "use_dxvk": True,
            "use_vkd3d": True,
            "use_gamescope": False,
            "mangohud": False,
            "gamemode": True,
        }

        config_file = self.config_dir / "config.json"
        if config_file.exists():
            try:
                with open(config_file, "r") as f:
                    self.config.update(json.load(f))
            except Exception:
                pass

    def save_config(self):
        config_file = self.config_dir / "config.json"
        with open(config_file, "w") as f:
            json.dump(self.config, f, indent=2)

    def handle_exe(self, exe_path):
        exe_path = Path(exe_path).resolve()

        if not exe_path.exists():
            self.show_error(f"File not found: {exe_path}")
            return False

        exe_name = exe_path.stem

        if self.is_installer(exe_path):
            return self.run_installer(exe_path)
        else:
            return self.run_exe(exe_path)

    def is_installer(self, exe_path):
        name = exe_path.stem.lower()
        installer_keywords = ["setup", "install", "installer", "update", "patch"]
        return any(keyword in name for keyword in installer_keywords)

    def run_installer(self, exe_path):
        app = InstallerApp(exe_path, self)
        return app.run(sys.argv[:1])

    def run_exe(self, exe_path):
        prefix = self.prefix_manager.get_or_create_prefix(self.config["default_prefix"])

        env = self.build_wine_env(prefix)

        try:
            subprocess.Popen(["wine", str(exe_path)], env=env, cwd=str(exe_path.parent))
            return True
        except Exception as e:
            self.show_error(f"Failed to run: {e}")
            return False

    def install_app(self, exe_path, app_name, prefix_name=None, create_desktop=True):
        if prefix_name is None:
            prefix_name = app_name.lower().replace(" ", "-")

        prefix = self.prefix_manager.get_or_create_prefix(prefix_name)

        self.prefix_manager.setup_prefix(
            prefix, dxvk=self.config["use_dxvk"], vkd3d=self.config["use_vkd3d"]
        )

        env = self.build_wine_env(prefix)

        try:
            process = subprocess.Popen(
                ["wine", str(exe_path)],
                env=env,
                cwd=str(exe_path.parent),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            process.wait()
        except Exception as e:
            return False, str(e)

        installed_exe = self.find_installed_exe(prefix, app_name)

        if installed_exe and create_desktop:
            icon_path = self.icon_extractor.extract(installed_exe, app_name)

            desktop_file = self.desktop_generator.create(
                app_name=app_name,
                exe_path=installed_exe,
                prefix=prefix,
                icon=icon_path,
                wine_env=env,
            )

            self.register_app(
                app_name,
                {
                    "exe": str(installed_exe),
                    "prefix": str(prefix),
                    "desktop": str(desktop_file),
                    "icon": str(icon_path) if icon_path else None,
                },
            )

            return True, desktop_file

        return True, None

    def find_installed_exe(self, prefix, app_name):
        drive_c = prefix / "drive_c"
        search_dirs = [
            drive_c / "Program Files",
            drive_c / "Program Files (x86)",
            drive_c / "users" / "Public" / "Desktop",
        ]

        name_lower = app_name.lower()

        for search_dir in search_dirs:
            if not search_dir.exists():
                continue

            for root, dirs, files in os.walk(search_dir):
                for file in files:
                    if file.lower().endswith(".exe"):
                        file_lower = file.lower()
                        if name_lower in file_lower or name_lower in root.lower():
                            if not any(
                                x in file_lower for x in ["unins", "update", "crash"]
                            ):
                                return Path(root) / file

        return None

    def build_wine_env(self, prefix):
        env = os.environ.copy()
        env["WINEPREFIX"] = str(prefix)
        env["WINEARCH"] = "win64"

        if self.config.get("use_dxvk"):
            env["DXVK_HUD"] = "fps,frametimes"

        if self.config.get("mangohud"):
            env["MANGOHUD"] = "1"

        return env

    def register_app(self, app_name, info):
        registry = {}
        if self.apps_registry.exists():
            try:
                with open(self.apps_registry, "r") as f:
                    registry = json.load(f)
            except Exception:
                pass

        registry[app_name] = info

        with open(self.apps_registry, "w") as f:
            json.dump(registry, f, indent=2)

    def show_error(self, message):
        print(f"Error: {message}", file=sys.stderr)


class InstallerWindow(Adw.ApplicationWindow):
    def __init__(self, app, exe_path, handler):
        super().__init__(application=app, title="Install Windows Application")
        self.set_default_size(500, 400)
        self.exe_path = Path(exe_path)
        self.handler = handler

        self.setup_ui()

    def setup_ui(self):
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(main_box)

        header = Adw.HeaderBar()
        main_box.append(header)

        content = Adw.Clamp()
        content.set_maximum_size(450)
        content.set_margin_top(24)
        content.set_margin_bottom(24)
        content.set_margin_start(24)
        content.set_margin_end(24)
        main_box.append(content)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=24)
        content.set_child(box)

        icon = Gtk.Image.new_from_icon_name("application-x-ms-dos-executable-symbolic")
        icon.set_pixel_size(64)
        box.append(icon)

        title = Gtk.Label(label=f"Install {self.exe_path.stem}")
        title.add_css_class("title-1")
        box.append(title)

        subtitle = Gtk.Label(
            label="This will create a Wine prefix and install the application"
        )
        subtitle.add_css_class("dim-label")
        box.append(subtitle)

        prefs = Adw.PreferencesGroup()
        box.append(prefs)

        self.name_row = Adw.EntryRow(title="Application Name")
        self.name_row.set_text(self.exe_path.stem)
        prefs.add(self.name_row)

        self.dxvk_switch = Adw.SwitchRow(
            title="Enable DXVK", subtitle="DirectX 9/10/11 to Vulkan"
        )
        self.dxvk_switch.set_active(True)
        prefs.add(self.dxvk_switch)

        self.vkd3d_switch = Adw.SwitchRow(
            title="Enable VKD3D-Proton", subtitle="DirectX 12 to Vulkan"
        )
        self.vkd3d_switch.set_active(True)
        prefs.add(self.vkd3d_switch)

        self.desktop_switch = Adw.SwitchRow(
            title="Create Desktop Entry", subtitle="Show in app grid after install"
        )
        self.desktop_switch.set_active(True)
        prefs.add(self.desktop_switch)

        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        button_box.set_halign(Gtk.Align.CENTER)
        button_box.set_margin_top(12)
        box.append(button_box)

        cancel_btn = Gtk.Button(label="Cancel")
        cancel_btn.connect("clicked", lambda _: self.close())
        button_box.append(cancel_btn)

        install_btn = Gtk.Button(label="Install")
        install_btn.add_css_class("suggested-action")
        install_btn.connect("clicked", self.on_install_clicked)
        button_box.append(install_btn)

        self.progress_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.progress_box.set_visible(False)
        box.append(self.progress_box)

        self.spinner = Gtk.Spinner()
        self.spinner.set_size_request(32, 32)
        self.progress_box.append(self.spinner)

        self.status_label = Gtk.Label(label="Installing...")
        self.progress_box.append(self.status_label)

    def on_install_clicked(self, button):
        app_name = self.name_row.get_text() or self.exe_path.stem

        self.handler.config["use_dxvk"] = self.dxvk_switch.get_active()
        self.handler.config["use_vkd3d"] = self.vkd3d_switch.get_active()
        self.handler.save_config()

        self.progress_box.set_visible(True)
        self.spinner.start()
        button.set_sensitive(False)

        import threading

        thread = threading.Thread(
            target=self._install_thread,
            args=(app_name, self.desktop_switch.get_active()),
        )
        thread.daemon = True
        thread.start()

    def _install_thread(self, app_name, create_desktop):
        success, result = self.handler.install_app(
            self.exe_path, app_name, create_desktop=create_desktop
        )

        GLib.idle_add(self._install_complete, success, result)

    def _install_complete(self, success, result):
        self.spinner.stop()

        if success:
            self.status_label.set_text("Installation complete!")

            dialog = Adw.MessageDialog(
                transient_for=self,
                heading="Installation Complete",
                body=f"The application has been installed and added to your applications.",
            )
            dialog.add_response("close", "Close")
            dialog.connect("response", lambda d, r: self.close())
            dialog.present()
        else:
            self.status_label.set_text(f"Installation failed: {result}")


class InstallerApp(Adw.Application):
    def __init__(self, exe_path, handler):
        super().__init__(
            application_id="org.tahoeos.wine-installer",
            flags=Gio.ApplicationFlags.FLAGS_NONE,
        )
        self.exe_path = exe_path
        self.handler = handler

    def do_activate(self):
        win = InstallerWindow(self, self.exe_path, self.handler)
        win.present()


def main():
    if len(sys.argv) < 2:
        print("Usage: tahoe-wine-handler <file.exe>")
        print("       tahoe-wine-handler --configure")
        sys.exit(1)

    handler = WineHandler()

    if sys.argv[1] == "--configure":
        print("Configuration mode not yet implemented")
        sys.exit(0)

    exe_path = sys.argv[1]
    success = handler.handle_exe(exe_path)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
