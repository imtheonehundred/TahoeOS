#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, Gio


class ControlCenterWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="System Settings")
        self.set_default_size(900, 600)

        paned = Gtk.Paned(orientation=Gtk.Orientation.HORIZONTAL)
        self.set_content(paned)

        sidebar = self.create_sidebar()
        paned.set_start_child(sidebar)
        paned.set_shrink_start_child(False)

        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        paned.set_end_child(self.stack)

        self.add_panel(
            "wifi", "Wi-Fi", "network-wireless-symbolic", self.create_wifi_panel()
        )
        self.add_panel(
            "bluetooth",
            "Bluetooth",
            "bluetooth-symbolic",
            self.create_bluetooth_panel(),
        )
        self.add_panel(
            "display", "Displays", "video-display-symbolic", self.create_display_panel()
        )
        self.add_panel(
            "sound", "Sound", "audio-volume-high-symbolic", self.create_sound_panel()
        )
        self.add_panel(
            "appearance",
            "Appearance",
            "preferences-desktop-wallpaper-symbolic",
            self.create_appearance_panel(),
        )
        self.add_panel(
            "notifications",
            "Notifications",
            "preferences-system-notifications-symbolic",
            self.create_notifications_panel(),
        )
        self.add_panel(
            "privacy",
            "Privacy & Security",
            "security-high-symbolic",
            self.create_privacy_panel(),
        )
        self.add_panel(
            "keyboard",
            "Keyboard",
            "input-keyboard-symbolic",
            self.create_keyboard_panel(),
        )
        self.add_panel(
            "mouse",
            "Mouse & Trackpad",
            "input-mouse-symbolic",
            self.create_mouse_panel(),
        )
        self.add_panel(
            "users", "Users", "system-users-symbolic", self.create_users_panel()
        )
        self.add_panel(
            "about", "About", "help-about-symbolic", self.create_about_panel()
        )

    def create_sidebar(self):
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_size_request(220, -1)

        self.listbox = Gtk.ListBox()
        self.listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.listbox.add_css_class("navigation-sidebar")
        self.listbox.connect("row-selected", self.on_row_selected)
        scrolled.set_child(self.listbox)

        return scrolled

    def add_panel(self, name, title, icon_name, widget):
        row = Gtk.ListBoxRow()
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        box.set_margin_start(12)
        box.set_margin_end(12)
        box.set_margin_top(8)
        box.set_margin_bottom(8)

        icon = Gtk.Image.new_from_icon_name(icon_name)
        box.append(icon)

        label = Gtk.Label(label=title)
        label.set_halign(Gtk.Align.START)
        box.append(label)

        row.set_child(box)
        row.panel_name = name
        self.listbox.append(row)

        self.stack.add_named(widget, name)

    def on_row_selected(self, listbox, row):
        if row:
            self.stack.set_visible_child_name(row.panel_name)

    def create_wifi_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Wi-Fi")
        toggle = Adw.SwitchRow(title="Wi-Fi", subtitle="Connected to network")
        toggle.set_active(True)
        group.add(toggle)
        page.add(group)
        return page

    def create_bluetooth_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Bluetooth")
        toggle = Adw.SwitchRow(title="Bluetooth", subtitle="Discoverable")
        toggle.set_active(True)
        group.add(toggle)
        page.add(group)
        return page

    def create_display_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Display Settings")
        night_light = Adw.SwitchRow(
            title="Night Light", subtitle="Reduce blue light at night"
        )
        group.add(night_light)
        page.add(group)
        return page

    def create_sound_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Sound")
        output = Adw.ComboRow(title="Output Device")
        group.add(output)
        page.add(group)
        return page

    def create_appearance_panel(self):
        page = Adw.PreferencesPage()
        theme_group = Adw.PreferencesGroup(title="Appearance")
        dark_mode = Adw.SwitchRow(title="Dark Mode")
        dark_mode.set_active(True)
        theme_group.add(dark_mode)
        page.add(theme_group)
        return page

    def create_notifications_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Notifications")
        dnd = Adw.SwitchRow(title="Do Not Disturb")
        group.add(dnd)
        page.add(group)
        return page

    def create_privacy_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Privacy & Security")
        firewall = Adw.SwitchRow(
            title="Firewall", subtitle="Block incoming connections"
        )
        firewall.set_active(True)
        group.add(firewall)
        page.add(group)
        return page

    def create_keyboard_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Keyboard")
        layout = Adw.ActionRow(title="Keyboard Layout", subtitle="US English")
        group.add(layout)
        page.add(group)
        return page

    def create_mouse_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Mouse & Trackpad")
        natural = Adw.SwitchRow(title="Natural Scrolling")
        natural.set_active(True)
        group.add(natural)
        tap = Adw.SwitchRow(title="Tap to Click")
        tap.set_active(True)
        group.add(tap)
        page.add(group)
        return page

    def create_users_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="Users")
        import os

        user = Adw.ActionRow(title=os.getenv("USER", "User"), subtitle="Administrator")
        group.add(user)
        page.add(group)
        return page

    def create_about_panel(self):
        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title="About This TahoeOS")

        os_row = Adw.ActionRow(title="TahoeOS", subtitle="Version 2026.1 (Tahoe)")
        group.add(os_row)

        import subprocess

        try:
            cpu = subprocess.check_output(["lscpu"], text=True)
            cpu_model = (
                [l for l in cpu.split("\n") if "Model name" in l][0]
                .split(":")[1]
                .strip()
            )
        except:
            cpu_model = "Unknown"

        cpu_row = Adw.ActionRow(title="Processor", subtitle=cpu_model)
        group.add(cpu_row)

        try:
            with open("/proc/meminfo") as f:
                mem = f.readline().split()[1]
                mem_gb = int(mem) // 1024 // 1024
        except:
            mem_gb = 0

        mem_row = Adw.ActionRow(title="Memory", subtitle=f"{mem_gb} GB")
        group.add(mem_row)

        page.add(group)
        return page


class ControlCenterApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.tahoeos.controlcenter")

    def do_activate(self):
        win = ControlCenterWindow(self)
        win.present()


def main():
    app = ControlCenterApp()
    app.run()


if __name__ == "__main__":
    main()
