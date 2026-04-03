#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib
import subprocess
import threading


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
            result = subprocess.run(
                ["dnf", "check-update", "-q"], capture_output=True, text=True
            )
            updates = [l for l in result.stdout.strip().split("\n") if l.strip()]
            GLib.idle_add(self._show_result, updates)
        except Exception as e:
            GLib.idle_add(self._show_error, str(e))

    def _show_result(self, updates):
        if updates:
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
