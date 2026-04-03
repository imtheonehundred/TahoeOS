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
            "gpu", "Graphics & Drivers", "video-card-symbolic", self.create_gpu_panel()
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

    def create_gpu_panel(self):
        page = Adw.PreferencesPage()

        import subprocess

        detected_gpus = self.detect_all_gpus()

        info_group = Adw.PreferencesGroup(
            title="Detected Graphics Cards",
            description="Current hardware detected on your system",
        )

        if not detected_gpus:
            no_gpu_row = Adw.ActionRow(
                title="No GPU Detected", subtitle="Using software rendering"
            )
            info_group.add(no_gpu_row)
        else:
            for gpu in detected_gpus:
                gpu_row = Adw.ActionRow(title=gpu["vendor"], subtitle=gpu["model"])
                info_group.add(gpu_row)

        page.add(info_group)

        nvidia_group = Adw.PreferencesGroup(
            title="NVIDIA Drivers",
            description="Proprietary drivers for NVIDIA graphics cards",
        )

        nvidia_status = self.check_nvidia_status(detected_gpus)
        nvidia_row = Adw.ActionRow(
            title="NVIDIA Proprietary Driver", subtitle=nvidia_status["status"]
        )

        if nvidia_status["action"] == "install":
            nvidia_btn = Gtk.Button(label="Install")
            nvidia_btn.add_css_class("suggested-action")
            nvidia_btn.set_valign(Gtk.Align.CENTER)
            nvidia_btn.connect("clicked", self.install_nvidia_drivers)
            nvidia_row.add_suffix(nvidia_btn)
        elif nvidia_status["action"] == "update":
            nvidia_btn = Gtk.Button(label="Update")
            nvidia_btn.add_css_class("suggested-action")
            nvidia_btn.set_valign(Gtk.Align.CENTER)
            nvidia_btn.connect("clicked", self.update_nvidia_drivers)
            nvidia_row.add_suffix(nvidia_btn)

        nvidia_group.add(nvidia_row)
        page.add(nvidia_group)

        amd_group = Adw.PreferencesGroup(
            title="AMD Drivers",
            description="Open source AMDGPU drivers (pre-installed)",
        )

        amd_status = self.check_amd_status(detected_gpus)
        amd_row = Adw.ActionRow(
            title="AMD Open Source Driver", subtitle=amd_status["status"]
        )

        if amd_status["action"] == "update":
            amd_btn = Gtk.Button(label="Update Mesa")
            amd_btn.add_css_class("suggested-action")
            amd_btn.set_valign(Gtk.Align.CENTER)
            amd_btn.connect("clicked", self.update_mesa_drivers)
            amd_row.add_suffix(amd_btn)

        amd_group.add(amd_row)
        page.add(amd_group)

        intel_group = Adw.PreferencesGroup(
            title="Intel Drivers",
            description="Open source Intel graphics drivers (pre-installed)",
        )

        intel_status = self.check_intel_status(detected_gpus)
        intel_row = Adw.ActionRow(
            title="Intel Open Source Driver", subtitle=intel_status["status"]
        )

        if intel_status["action"] == "update":
            intel_btn = Gtk.Button(label="Update Mesa")
            intel_btn.add_css_class("suggested-action")
            intel_btn.set_valign(Gtk.Align.CENTER)
            intel_btn.connect("clicked", self.update_mesa_drivers)
            intel_row.add_suffix(intel_btn)

        intel_group.add(intel_row)
        page.add(intel_group)

        return page

    def detect_all_gpus(self):
        import subprocess

        gpus = []
        try:
            lspci = subprocess.check_output(["lspci", "-nn"], text=True)
            for line in lspci.split("\n"):
                if "VGA" in line or "3D" in line or "Display" in line:
                    if "NVIDIA" in line.upper():
                        model = (
                            line.split(":", 2)[2].strip()
                            if len(line.split(":", 2)) > 2
                            else "NVIDIA GPU"
                        )
                        gpus.append({"vendor": "NVIDIA", "model": model[:60]})
                    elif "AMD" in line.upper() or "ATI" in line.upper():
                        model = (
                            line.split(":", 2)[2].strip()
                            if len(line.split(":", 2)) > 2
                            else "AMD GPU"
                        )
                        gpus.append({"vendor": "AMD", "model": model[:60]})
                    elif "INTEL" in line.upper():
                        model = (
                            line.split(":", 2)[2].strip()
                            if len(line.split(":", 2)) > 2
                            else "Intel GPU"
                        )
                        gpus.append({"vendor": "Intel", "model": model[:60]})
        except:
            pass

        return gpus

    def check_nvidia_status(self, detected_gpus):
        import subprocess

        has_nvidia = any(gpu["vendor"] == "NVIDIA" for gpu in detected_gpus)

        if not has_nvidia:
            return {"status": "No NVIDIA GPU detected", "action": None}

        try:
            result = subprocess.run(
                ["nvidia-smi"], capture_output=True, check=True, text=True
            )
            driver_line = [
                l for l in result.stdout.split("\n") if "Driver Version:" in l
            ]
            if driver_line:
                version = driver_line[0].split("Driver Version:")[1].split()[0]
                return {"status": f"Installed (v{version})", "action": "update"}
            return {"status": "Installed", "action": "update"}
        except:
            return {
                "status": "Not installed (using Nouveau open source driver)",
                "action": "install",
            }

    def check_amd_status(self, detected_gpus):
        import subprocess

        has_amd = any(gpu["vendor"] == "AMD" for gpu in detected_gpus)

        if not has_amd:
            return {"status": "No AMD GPU detected", "action": None}

        try:
            result = subprocess.run(["glxinfo"], capture_output=True, text=True)
            if "AMD" in result.stdout or "Radeon" in result.stdout:
                return {
                    "status": "Installed and active (AMDGPU Mesa driver)",
                    "action": "update",
                }
        except:
            pass

        return {"status": "Installed (AMDGPU Mesa driver)", "action": "update"}

    def check_intel_status(self, detected_gpus):
        import subprocess

        has_intel = any(gpu["vendor"] == "Intel" for gpu in detected_gpus)

        if not has_intel:
            return {"status": "No Intel GPU detected", "action": None}

        try:
            result = subprocess.run(["glxinfo"], capture_output=True, text=True)
            if "Intel" in result.stdout:
                return {
                    "status": "Installed and active (Intel Mesa driver)",
                    "action": "update",
                }
        except:
            pass

        return {"status": "Installed (Intel Mesa driver)", "action": "update"}

    def update_nvidia_drivers(self, btn):
        dialog = Adw.MessageDialog(
            transient_for=self,
            heading="Update NVIDIA Drivers?",
            body="This will update NVIDIA proprietary drivers to the latest version.",
        )
        dialog.add_response("cancel", "Cancel")
        dialog.add_response("update", "Update")
        dialog.set_response_appearance("update", Adw.ResponseAppearance.SUGGESTED)
        dialog.connect("response", self.on_nvidia_update_response)
        dialog.present()

    def on_nvidia_update_response(self, dialog, response):
        if response == "update":
            import subprocess

            subprocess.Popen(
                [
                    "gnome-terminal",
                    "--",
                    "sudo",
                    "dnf",
                    "update",
                    "-y",
                    "akmod-nvidia",
                    "xorg-x11-drv-nvidia-cuda",
                ]
            )

    def update_mesa_drivers(self, btn):
        dialog = Adw.MessageDialog(
            transient_for=self,
            heading="Update Mesa Drivers?",
            body="This will update Mesa graphics drivers to the latest version.",
        )
        dialog.add_response("cancel", "Cancel")
        dialog.add_response("update", "Update")
        dialog.set_response_appearance("update", Adw.ResponseAppearance.SUGGESTED)
        dialog.connect("response", self.on_mesa_update_response)
        dialog.present()

    def on_mesa_update_response(self, dialog, response):
        if response == "update":
            import subprocess

            subprocess.Popen(
                ["gnome-terminal", "--", "sudo", "dnf", "update", "-y", "mesa-*"]
            )

    def install_nvidia_drivers(self, btn):
        import subprocess

        dialog = Adw.MessageDialog(
            transient_for=self,
            heading="Install NVIDIA Drivers?",
            body="This will install proprietary NVIDIA drivers. A reboot will be required.",
        )
        dialog.add_response("cancel", "Cancel")
        dialog.add_response("install", "Install")
        dialog.set_response_appearance("install", Adw.ResponseAppearance.SUGGESTED)
        dialog.connect("response", self.on_nvidia_install_response)
        dialog.present()

    def on_nvidia_install_response(self, dialog, response):
        if response == "install":
            import subprocess

            subprocess.Popen(
                [
                    "gnome-terminal",
                    "--",
                    "sudo",
                    "dnf",
                    "install",
                    "-y",
                    "akmod-nvidia",
                    "xorg-x11-drv-nvidia-cuda",
                ]
            )

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
