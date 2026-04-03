#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib
import subprocess
import threading
import json
import urllib.request


class UpdateWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Software Update")
        self.set_default_size(500, 400)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)

        header = Adw.HeaderBar()
        box.append(header)

        self.status = Adw.StatusPage()
        self.status.set_icon_name("software-update-available-symbolic")
        self.status.set_title("Checking for updates...")
        box.append(self.status)

        self.button = Gtk.Button(label="Check for Updates")
        self.button.add_css_class("suggested-action")
        self.button.set_halign(Gtk.Align.CENTER)
        self.button.set_margin_bottom(24)
        self.button.connect("clicked", self.check_updates)
        box.append(self.button)

        GLib.idle_add(self.check_updates, None)

    def check_updates(self, btn):
        self.status.set_title("Checking for updates...")
        self.button.set_sensitive(False)

        thread = threading.Thread(target=self._check_thread)
        thread.daemon = True
        thread.start()

    def _check_thread(self):
        try:
            # Check TahoeOS version from GitHub
            tahoeos_update = self._check_tahoeos_version()

            # Check Fedora/system updates
            result = subprocess.run(
                ["dnf", "check-update", "-q"], capture_output=True, text=True
            )
            updates = [l for l in result.stdout.strip().split("\n") if l.strip()]

            GLib.idle_add(self._show_result, updates, tahoeos_update)
        except Exception as e:
            GLib.idle_add(self._show_error, str(e))

    def _check_tahoeos_version(self):
        """Check GitHub for newer TahoeOS release"""
        try:
            with urllib.request.urlopen(
                "https://api.github.com/repos/imtheonehundred/TahoeOS/releases/latest"
            ) as response:
                data = json.loads(response.read().decode())
                latest_version = data.get("tag_name", "").replace("v", "")
                current_version = "2026.1"  # Read from /etc/os-release

                if latest_version and latest_version > current_version:
                    return {
                        "available": True,
                        "version": latest_version,
                        "url": data.get("html_url"),
                        "iso_url": data.get("assets", [{}])[0].get(
                            "browser_download_url"
                        ),
                    }
        except:
            pass
        return {"available": False}

    def _show_result(self, updates, tahoeos_update):
        if tahoeos_update.get("available"):
            self.status.set_title(f"TahoeOS {tahoeos_update['version']} available!")
            self.status.set_description(
                f"A new version of TahoeOS is available.\n"
                f"Download the new ISO to upgrade.\n\n"
                f"System updates: {len(updates)} packages"
            )
            self.button.set_label("View Release")
            self.button.disconnect_by_func(self.check_updates)
            self.button.connect(
                "clicked", lambda b: subprocess.run(["xdg-open", tahoeos_update["url"]])
            )
        elif updates:
            self.status.set_title(f"{len(updates)} updates available")
            self.status.set_description("Click Update All to install")
            self.button.set_label("Update All")
            self.button.disconnect_by_func(self.check_updates)
            self.button.connect("clicked", self.install_updates)
        else:
            self.status.set_title("TahoeOS is up to date")
            self.status.set_description("Last checked: just now")
            self.button.set_label("Check Again")
        self.button.set_sensitive(True)

    def _show_error(self, error):
        self.status.set_title("Error checking updates")
        self.status.set_description(error)
        self.button.set_sensitive(True)

    def install_updates(self, btn):
        self.status.set_title("Installing updates...")
        self.button.set_sensitive(False)

        thread = threading.Thread(target=self._install_thread)
        thread.daemon = True
        thread.start()

    def _install_thread(self):
        try:
            subprocess.run(["pkexec", "dnf", "upgrade", "-y"], check=True)
            GLib.idle_add(self._install_complete)
        except Exception as e:
            GLib.idle_add(self._show_error, str(e))

    def _install_complete(self):
        self.status.set_title("Updates installed!")
        self.status.set_description("You may need to restart")
        self.button.set_label("Close")
        self.button.set_sensitive(True)
        self.button.disconnect_by_func(self.install_updates)
        self.button.connect("clicked", lambda x: self.close())


class UpdateApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.tahoeos.updatemanager")

    def do_activate(self):
        win = UpdateWindow(self)
        win.present()


def main():
    app = UpdateApp()
    app.run()


if __name__ == "__main__":
    main()
