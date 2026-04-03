#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, GLib, Gio
import sys
import threading

from backends.dnf_backend import DnfBackend
from backends.flatpak_backend import FlatpakBackend
from backends.wine_backend import WineBackend
from backends.appimage_backend import AppImageBackend


class AppStoreWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="App Store")
        self.set_default_size(1200, 800)

        self.backends = {
            "dnf": DnfBackend(),
            "flatpak": FlatpakBackend(),
            "wine": WineBackend(),
            "appimage": AppImageBackend(),
        }

        self.all_apps = []
        self.current_filter = "all"
        self.search_query = ""

        self.setup_ui()
        self.load_apps()

    def setup_ui(self):
        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(self.main_box)

        header = Adw.HeaderBar()
        self.main_box.append(header)

        self.search_entry = Gtk.SearchEntry()
        self.search_entry.set_placeholder_text("Search apps...")
        self.search_entry.set_hexpand(True)
        self.search_entry.connect("search-changed", self.on_search_changed)
        header.set_title_widget(self.search_entry)

        content_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        content_box.set_vexpand(True)
        self.main_box.append(content_box)

        sidebar = self.create_sidebar()
        content_box.append(sidebar)

        separator = Gtk.Separator(orientation=Gtk.Orientation.VERTICAL)
        content_box.append(separator)

        self.scrolled = Gtk.ScrolledWindow()
        self.scrolled.set_hexpand(True)
        self.scrolled.set_vexpand(True)
        content_box.append(self.scrolled)

        self.apps_grid = Gtk.FlowBox()
        self.apps_grid.set_valign(Gtk.Align.START)
        self.apps_grid.set_max_children_per_line(6)
        self.apps_grid.set_min_children_per_line(2)
        self.apps_grid.set_selection_mode(Gtk.SelectionMode.NONE)
        self.apps_grid.set_homogeneous(True)
        self.apps_grid.set_column_spacing(16)
        self.apps_grid.set_row_spacing(16)
        self.apps_grid.set_margin_start(24)
        self.apps_grid.set_margin_end(24)
        self.apps_grid.set_margin_top(24)
        self.apps_grid.set_margin_bottom(24)
        self.scrolled.set_child(self.apps_grid)

        self.spinner = Gtk.Spinner()
        self.spinner.set_size_request(48, 48)

        self.status_page = Adw.StatusPage()
        self.status_page.set_title("Loading Apps...")
        self.status_page.set_child(self.spinner)

    def create_sidebar(self):
        sidebar_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        sidebar_box.set_size_request(220, -1)
        sidebar_box.add_css_class("sidebar")

        categories = [
            ("all", "All Apps", "view-app-grid-symbolic"),
            ("installed", "Installed", "emblem-ok-symbolic"),
            ("updates", "Updates", "software-update-available-symbolic"),
            ("linux", "Linux Apps", "application-x-executable-symbolic"),
            ("flatpak", "Flatpak", "package-x-generic-symbolic"),
            ("windows", "Windows Apps", "application-x-ms-dos-executable-symbolic"),
            ("appimage", "AppImages", "application-x-appimage-symbolic"),
            ("games", "Games", "input-gaming-symbolic"),
            ("development", "Development", "utilities-terminal-symbolic"),
            ("graphics", "Graphics", "applications-graphics-symbolic"),
            ("audio", "Audio & Video", "applications-multimedia-symbolic"),
            ("office", "Office", "x-office-document-symbolic"),
        ]

        list_box = Gtk.ListBox()
        list_box.set_selection_mode(Gtk.SelectionMode.SINGLE)
        list_box.add_css_class("navigation-sidebar")
        list_box.connect("row-selected", self.on_category_selected)
        sidebar_box.append(list_box)

        for cat_id, cat_name, icon_name in categories:
            row = Gtk.ListBoxRow()
            row.cat_id = cat_id

            box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
            box.set_margin_start(12)
            box.set_margin_end(12)
            box.set_margin_top(8)
            box.set_margin_bottom(8)

            icon = Gtk.Image.new_from_icon_name(icon_name)
            box.append(icon)

            label = Gtk.Label(label=cat_name)
            label.set_halign(Gtk.Align.START)
            label.set_hexpand(True)
            box.append(label)

            row.set_child(box)
            list_box.append(row)

            if cat_id == "all":
                list_box.select_row(row)

        return sidebar_box

    def on_category_selected(self, listbox, row):
        if row:
            self.current_filter = row.cat_id
            self.filter_apps()

    def on_search_changed(self, entry):
        self.search_query = entry.get_text().lower()
        self.filter_apps()

    def load_apps(self):
        self.scrolled.set_child(self.status_page)
        self.spinner.start()

        thread = threading.Thread(target=self._load_apps_thread)
        thread.daemon = True
        thread.start()

    def _load_apps_thread(self):
        apps = []
        for name, backend in self.backends.items():
            try:
                backend_apps = backend.get_apps()
                apps.extend(backend_apps)
            except Exception as e:
                print(f"Error loading {name} backend: {e}")

        self.all_apps = apps
        GLib.idle_add(self._finish_loading)

    def _finish_loading(self):
        self.spinner.stop()
        self.scrolled.set_child(self.apps_grid)
        self.filter_apps()

    def filter_apps(self):
        while True:
            child = self.apps_grid.get_first_child()
            if child is None:
                break
            self.apps_grid.remove(child)

        filtered = []
        for app in self.all_apps:
            if (
                self.search_query
                and self.search_query not in app.get("name", "").lower()
            ):
                if self.search_query not in app.get("description", "").lower():
                    continue

            if self.current_filter == "all":
                filtered.append(app)
            elif self.current_filter == "installed" and app.get("installed"):
                filtered.append(app)
            elif self.current_filter == "updates" and app.get("has_update"):
                filtered.append(app)
            elif self.current_filter == "linux" and app.get("source") == "dnf":
                filtered.append(app)
            elif self.current_filter == "flatpak" and app.get("source") == "flatpak":
                filtered.append(app)
            elif self.current_filter == "windows" and app.get("source") == "wine":
                filtered.append(app)
            elif self.current_filter == "appimage" and app.get("source") == "appimage":
                filtered.append(app)
            elif self.current_filter == "games" and "Game" in app.get("categories", []):
                filtered.append(app)
            elif self.current_filter == "development" and "Development" in app.get(
                "categories", []
            ):
                filtered.append(app)
            elif self.current_filter == "graphics" and "Graphics" in app.get(
                "categories", []
            ):
                filtered.append(app)
            elif self.current_filter == "audio" and (
                "Audio" in app.get("categories", [])
                or "Video" in app.get("categories", [])
            ):
                filtered.append(app)
            elif self.current_filter == "office" and "Office" in app.get(
                "categories", []
            ):
                filtered.append(app)

        for app in filtered[:100]:
            card = self.create_app_card(app)
            self.apps_grid.append(card)

    def create_app_card(self, app):
        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        card.set_size_request(160, 180)
        card.add_css_class("card")
        card.set_margin_start(8)
        card.set_margin_end(8)
        card.set_margin_top(8)
        card.set_margin_bottom(8)

        icon_name = app.get("icon", "application-x-executable-symbolic")
        icon = Gtk.Image.new_from_icon_name(icon_name)
        icon.set_pixel_size(64)
        icon.set_margin_top(16)
        card.append(icon)

        name_label = Gtk.Label(label=app.get("name", "Unknown"))
        name_label.set_ellipsize(3)
        name_label.set_max_width_chars(18)
        name_label.add_css_class("title-4")
        card.append(name_label)

        source_label = Gtk.Label(label=app.get("source", "").upper())
        source_label.add_css_class("dim-label")
        source_label.add_css_class("caption")
        card.append(source_label)

        if app.get("installed"):
            button = Gtk.Button(label="Open")
            button.add_css_class("suggested-action")
        else:
            button = Gtk.Button(label="Install")

        button.set_margin_start(16)
        button.set_margin_end(16)
        button.set_margin_bottom(16)
        button.connect("clicked", self.on_app_action, app)
        card.append(button)

        return card

    def on_app_action(self, button, app):
        if app.get("installed"):
            self.launch_app(app)
        else:
            self.install_app(app, button)

    def launch_app(self, app):
        desktop_file = app.get("desktop_file")
        if desktop_file:
            app_info = Gio.DesktopAppInfo.new_from_filename(desktop_file)
            if app_info:
                app_info.launch([], None)

    def install_app(self, app, button):
        button.set_sensitive(False)
        button.set_label("Installing...")

        source = app.get("source")
        backend = self.backends.get(source)

        if backend:
            thread = threading.Thread(
                target=self._install_thread, args=(backend, app, button)
            )
            thread.daemon = True
            thread.start()

    def _install_thread(self, backend, app, button):
        try:
            success = backend.install(app)
            GLib.idle_add(self._install_complete, button, success)
        except Exception as e:
            print(f"Install error: {e}")
            GLib.idle_add(self._install_complete, button, False)

    def _install_complete(self, button, success):
        if success:
            button.set_label("Open")
            button.add_css_class("suggested-action")
        else:
            button.set_label("Failed")
            button.add_css_class("destructive-action")
        button.set_sensitive(True)


class AppStoreApp(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id="org.tahoeos.appstore", flags=Gio.ApplicationFlags.FLAGS_NONE
        )

    def do_activate(self):
        win = AppStoreWindow(self)
        win.present()


def main():
    app = AppStoreApp()
    return app.run(sys.argv)


if __name__ == "__main__":
    sys.exit(main())
