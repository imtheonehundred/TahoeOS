import subprocess
import json
import os
from pathlib import Path


class DnfBackend:
    def __init__(self):
        self.cache_file = Path.home() / ".cache" / "tahoe-app-store" / "dnf_cache.json"
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)

    def get_apps(self):
        apps = []

        installed = self._get_installed_gui_apps()
        for pkg in installed:
            apps.append(
                {
                    "id": f"dnf:{pkg['name']}",
                    "name": pkg["name"],
                    "version": pkg["version"],
                    "description": pkg.get("summary", ""),
                    "icon": self._find_icon(pkg["name"]),
                    "source": "dnf",
                    "installed": True,
                    "package_name": pkg["name"],
                    "desktop_file": pkg.get("desktop_file"),
                    "categories": pkg.get("categories", []),
                }
            )

        popular = [
            "firefox",
            "thunderbird",
            "libreoffice",
            "gimp",
            "inkscape",
            "blender",
            "kdenlive",
            "obs-studio",
            "vlc",
            "audacity",
            "code",
            "gnome-boxes",
            "transmission-gtk",
            "rhythmbox",
            "cheese",
            "simple-scan",
            "gnome-maps",
            "gnome-weather",
            "gnome-calculator",
            "gnome-calendar",
            "evince",
            "eog",
            "gedit",
            "gnome-terminal",
            "nautilus",
            "gnome-tweaks",
        ]

        for pkg_name in popular:
            if not any(a["package_name"] == pkg_name for a in apps):
                info = self._get_package_info(pkg_name)
                if info:
                    apps.append(
                        {
                            "id": f"dnf:{pkg_name}",
                            "name": info.get("name", pkg_name),
                            "version": info.get("version", ""),
                            "description": info.get("summary", ""),
                            "icon": self._find_icon(pkg_name),
                            "source": "dnf",
                            "installed": False,
                            "package_name": pkg_name,
                            "categories": [],
                        }
                    )

        return apps

    def _get_installed_gui_apps(self):
        apps = []
        desktop_dirs = [
            "/usr/share/applications",
            str(Path.home() / ".local" / "share" / "applications"),
        ]

        for desktop_dir in desktop_dirs:
            if not os.path.exists(desktop_dir):
                continue

            for filename in os.listdir(desktop_dir):
                if not filename.endswith(".desktop"):
                    continue

                desktop_path = os.path.join(desktop_dir, filename)
                try:
                    app_info = self._parse_desktop_file(desktop_path)
                    if app_info and not app_info.get("no_display"):
                        pkg = self._get_package_for_desktop(desktop_path)
                        if pkg:
                            apps.append(
                                {
                                    "name": app_info.get(
                                        "name", filename.replace(".desktop", "")
                                    ),
                                    "version": pkg.get("version", ""),
                                    "summary": app_info.get("comment", ""),
                                    "desktop_file": desktop_path,
                                    "categories": app_info.get("categories", []),
                                }
                            )
                except Exception:
                    pass

        return apps

    def _parse_desktop_file(self, path):
        info = {}
        try:
            with open(path, "r") as f:
                in_desktop_entry = False
                for line in f:
                    line = line.strip()
                    if line == "[Desktop Entry]":
                        in_desktop_entry = True
                        continue
                    if line.startswith("[") and line.endswith("]"):
                        in_desktop_entry = False
                        continue
                    if in_desktop_entry and "=" in line:
                        key, value = line.split("=", 1)
                        if key == "Name":
                            info["name"] = value
                        elif key == "Comment":
                            info["comment"] = value
                        elif key == "Icon":
                            info["icon"] = value
                        elif key == "NoDisplay":
                            info["no_display"] = value.lower() == "true"
                        elif key == "Categories":
                            info["categories"] = value.split(";")
        except Exception:
            pass
        return info

    def _get_package_for_desktop(self, desktop_path):
        try:
            result = subprocess.run(
                ["rpm", "-qf", desktop_path, "--queryformat", "%{NAME}|%{VERSION}"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode == 0:
                parts = result.stdout.strip().split("|")
                return {"name": parts[0], "version": parts[1] if len(parts) > 1 else ""}
        except Exception:
            pass
        return None

    def _get_package_info(self, pkg_name):
        try:
            result = subprocess.run(
                ["dnf", "info", "--quiet", pkg_name],
                capture_output=True,
                text=True,
                timeout=30,
            )
            if result.returncode == 0:
                info = {"name": pkg_name}
                for line in result.stdout.split("\n"):
                    if ":" in line:
                        key, value = line.split(":", 1)
                        key = key.strip().lower()
                        value = value.strip()
                        if key == "version":
                            info["version"] = value
                        elif key == "summary":
                            info["summary"] = value
                return info
        except Exception:
            pass
        return None

    def _find_icon(self, name):
        icon_dirs = [
            "/usr/share/icons/hicolor/scalable/apps",
            "/usr/share/icons/hicolor/256x256/apps",
            "/usr/share/icons/hicolor/128x128/apps",
            "/usr/share/icons/hicolor/64x64/apps",
            "/usr/share/icons/hicolor/48x48/apps",
            "/usr/share/pixmaps",
        ]

        for icon_dir in icon_dirs:
            for ext in [".svg", ".png", ".xpm"]:
                icon_path = os.path.join(icon_dir, name + ext)
                if os.path.exists(icon_path):
                    return icon_path

        return "application-x-executable-symbolic"

    def install(self, app):
        pkg_name = app.get("package_name")
        if not pkg_name:
            return False

        try:
            result = subprocess.run(
                ["pkexec", "dnf", "install", "-y", pkg_name],
                capture_output=True,
                text=True,
                timeout=300,
            )
            return result.returncode == 0
        except Exception as e:
            print(f"DNF install error: {e}")
            return False

    def uninstall(self, app):
        pkg_name = app.get("package_name")
        if not pkg_name:
            return False

        try:
            result = subprocess.run(
                ["pkexec", "dnf", "remove", "-y", pkg_name],
                capture_output=True,
                text=True,
                timeout=300,
            )
            return result.returncode == 0
        except Exception:
            return False
