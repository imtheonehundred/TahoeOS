#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib
import subprocess
import threading
import json
from datetime import datetime


class BackupWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Time Machine")
        self.set_default_size(600, 500)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)

        header = Adw.HeaderBar()
        box.append(header)

        content = Adw.PreferencesPage()
        box.append(content)

        status_group = Adw.PreferencesGroup(title="Backup Status")
        content.add(status_group)

        self.status_row = Adw.ActionRow(title="Last Backup", subtitle="Checking...")
        status_group.add(self.status_row)

        actions_group = Adw.PreferencesGroup(title="Actions")
        content.add(actions_group)

        backup_row = Adw.ActionRow(title="Back Up Now", subtitle="Create a snapshot")
        backup_btn = Gtk.Button(label="Backup")
        backup_btn.set_valign(Gtk.Align.CENTER)
        backup_btn.connect("clicked", self.do_backup)
        backup_row.add_suffix(backup_btn)
        actions_group.add(backup_row)

        restore_row = Adw.ActionRow(
            title="Restore", subtitle="Browse previous snapshots"
        )
        restore_btn = Gtk.Button(label="Browse")
        restore_btn.set_valign(Gtk.Align.CENTER)
        restore_btn.connect("clicked", self.browse_snapshots)
        restore_row.add_suffix(restore_btn)
        actions_group.add(restore_row)

        self.snapshots_group = Adw.PreferencesGroup(title="Snapshots")
        content.add(self.snapshots_group)

        GLib.idle_add(self.load_snapshots)

    def load_snapshots(self):
        thread = threading.Thread(target=self._load_thread)
        thread.daemon = True
        thread.start()

    def _load_thread(self):
        try:
            result = subprocess.run(
                ["snapper", "list", "--json"], capture_output=True, text=True
            )
            snapshots = json.loads(result.stdout) if result.returncode == 0 else []
            GLib.idle_add(self._show_snapshots, snapshots)
        except:
            GLib.idle_add(self._show_snapshots, [])

    def _show_snapshots(self, snapshots):
        child = self.snapshots_group.get_first_child()
        while child:
            next_child = child.get_next_sibling()
            self.snapshots_group.remove(child)
            child = next_child

        if not snapshots:
            self.status_row.set_subtitle("No backups yet")
            return

        for snap in snapshots[-5:]:
            if isinstance(snap, dict):
                num = snap.get("number", "?")
                date = snap.get("date", "Unknown")
                desc = snap.get("description", "Snapshot")
                row = Adw.ActionRow(
                    title=f"Snapshot #{num}", subtitle=f"{date} - {desc}"
                )
                self.snapshots_group.add(row)

        if snapshots:
            last = snapshots[-1]
            self.status_row.set_subtitle(f"Last: {last.get('date', 'Unknown')}")

    def do_backup(self, btn):
        btn.set_sensitive(False)
        btn.set_label("Creating...")

        def backup_thread():
            try:
                desc = f"Manual backup {datetime.now().strftime('%Y-%m-%d %H:%M')}"
                subprocess.run(["pkexec", "snapper", "create", "-d", desc], check=True)
                GLib.idle_add(self._backup_done, btn, True)
            except:
                GLib.idle_add(self._backup_done, btn, False)

        threading.Thread(target=backup_thread, daemon=True).start()

    def _backup_done(self, btn, success):
        btn.set_label("Backup" if success else "Failed")
        btn.set_sensitive(True)
        if success:
            self.load_snapshots()

    def browse_snapshots(self, btn):
        subprocess.Popen(["nautilus", "/.snapshots"])


class BackupApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.tahoeos.backup")

    def do_activate(self):
        win = BackupWindow(self)
        win.present()


if __name__ == "__main__":
    app = BackupApp()
    app.run()
