import subprocess
import json
import os
from pathlib import Path


class FlatpakBackend:
    def __init__(self):
        self.cache_file = (
            Path.home() / ".cache" / "tahoe-app-store" / "flatpak_cache.json"
        )
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)

    def get_apps(self):
        apps = []

        installed = self._get_installed_apps()
        for app_info in installed:
            apps.append(
                {
                    "id": f"flatpak:{app_info['id']}",
                    "name": app_info["name"],
                    "version": app_info.get("version", ""),
                    "description": app_info.get("description", ""),
                    "icon": self._find_icon(app_info["id"]),
                    "source": "flatpak",
                    "installed": True,
                    "flatpak_id": app_info["id"],
                    "desktop_file": app_info.get("desktop_file"),
                    "categories": app_info.get("categories", []),
                }
            )

        popular = self._get_popular_apps()
        for app_info in popular:
            if not any(a.get("flatpak_id") == app_info["id"] for a in apps):
                apps.append(
                    {
                        "id": f"flatpak:{app_info['id']}",
                        "name": app_info["name"],
                        "version": "",
                        "description": app_info.get("description", ""),
                        "icon": app_info.get(
                            "icon", "application-x-executable-symbolic"
                        ),
                        "source": "flatpak",
                        "installed": False,
                        "flatpak_id": app_info["id"],
                        "categories": app_info.get("categories", []),
                    }
                )

        return apps

    def _get_installed_apps(self):
        apps = []
        try:
            result = subprocess.run(
                ["flatpak", "list", "--app", "--columns=application,name,version"],
                capture_output=True,
                text=True,
                timeout=30,
            )
            if result.returncode == 0:
                for line in result.stdout.strip().split("\n"):
                    if not line.strip():
                        continue
                    parts = line.split("\t")
                    if len(parts) >= 2:
                        app_id = parts[0].strip()
                        name = parts[1].strip()
                        version = parts[2].strip() if len(parts) > 2 else ""

                        desktop_file = self._find_desktop_file(app_id)
                        categories = []
                        if desktop_file:
                            categories = self._get_categories(desktop_file)

                        apps.append(
                            {
                                "id": app_id,
                                "name": name,
                                "version": version,
                                "desktop_file": desktop_file,
                                "categories": categories,
                            }
                        )
        except Exception as e:
            print(f"Error getting installed flatpaks: {e}")
        return apps

    def _find_desktop_file(self, app_id):
        paths = [
            f"/var/lib/flatpak/exports/share/applications/{app_id}.desktop",
            str(
                Path.home()
                / ".local"
                / "share"
                / "flatpak"
                / "exports"
                / "share"
                / "applications"
                / f"{app_id}.desktop"
            ),
        ]
        for path in paths:
            if os.path.exists(path):
                return path
        return None

    def _get_categories(self, desktop_file):
        try:
            with open(desktop_file, "r") as f:
                for line in f:
                    if line.startswith("Categories="):
                        return line.split("=", 1)[1].strip().split(";")
        except Exception:
            pass
        return []

    def _get_popular_apps(self):
        return [
            {
                "id": "org.mozilla.firefox",
                "name": "Firefox",
                "description": "Web browser",
                "categories": ["Network"],
            },
            {
                "id": "com.google.Chrome",
                "name": "Google Chrome",
                "description": "Web browser",
                "categories": ["Network"],
            },
            {
                "id": "com.spotify.Client",
                "name": "Spotify",
                "description": "Music streaming",
                "categories": ["Audio"],
            },
            {
                "id": "com.discordapp.Discord",
                "name": "Discord",
                "description": "Chat app",
                "categories": ["Network"],
            },
            {
                "id": "com.slack.Slack",
                "name": "Slack",
                "description": "Team messaging",
                "categories": ["Network"],
            },
            {
                "id": "us.zoom.Zoom",
                "name": "Zoom",
                "description": "Video meetings",
                "categories": ["Network"],
            },
            {
                "id": "com.valvesoftware.Steam",
                "name": "Steam",
                "description": "Gaming platform",
                "categories": ["Game"],
            },
            {
                "id": "com.heroicgameslauncher.hgl",
                "name": "Heroic Games",
                "description": "Epic/GOG launcher",
                "categories": ["Game"],
            },
            {
                "id": "net.lutris.Lutris",
                "name": "Lutris",
                "description": "Game manager",
                "categories": ["Game"],
            },
            {
                "id": "com.usebottles.bottles",
                "name": "Bottles",
                "description": "Windows apps",
                "categories": ["Utility"],
            },
            {
                "id": "org.gimp.GIMP",
                "name": "GIMP",
                "description": "Image editor",
                "categories": ["Graphics"],
            },
            {
                "id": "org.inkscape.Inkscape",
                "name": "Inkscape",
                "description": "Vector graphics",
                "categories": ["Graphics"],
            },
            {
                "id": "org.blender.Blender",
                "name": "Blender",
                "description": "3D creation",
                "categories": ["Graphics"],
            },
            {
                "id": "org.videolan.VLC",
                "name": "VLC",
                "description": "Media player",
                "categories": ["Video"],
            },
            {
                "id": "org.kde.kdenlive",
                "name": "Kdenlive",
                "description": "Video editor",
                "categories": ["Video"],
            },
            {
                "id": "com.obsproject.Studio",
                "name": "OBS Studio",
                "description": "Streaming",
                "categories": ["Video"],
            },
            {
                "id": "org.audacityteam.Audacity",
                "name": "Audacity",
                "description": "Audio editor",
                "categories": ["Audio"],
            },
            {
                "id": "com.visualstudio.code",
                "name": "VS Code",
                "description": "Code editor",
                "categories": ["Development"],
            },
            {
                "id": "org.telegram.desktop",
                "name": "Telegram",
                "description": "Messenger",
                "categories": ["Network"],
            },
            {
                "id": "org.libreoffice.LibreOffice",
                "name": "LibreOffice",
                "description": "Office suite",
                "categories": ["Office"],
            },
        ]

    def _find_icon(self, app_id):
        icon_paths = [
            f"/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/{app_id}.svg",
            f"/var/lib/flatpak/exports/share/icons/hicolor/256x256/apps/{app_id}.png",
            f"/var/lib/flatpak/exports/share/icons/hicolor/128x128/apps/{app_id}.png",
            str(
                Path.home()
                / ".local"
                / "share"
                / "flatpak"
                / "exports"
                / "share"
                / "icons"
                / "hicolor"
                / "scalable"
                / "apps"
                / f"{app_id}.svg"
            ),
        ]
        for path in icon_paths:
            if os.path.exists(path):
                return path
        return "application-x-executable-symbolic"

    def install(self, app):
        flatpak_id = app.get("flatpak_id")
        if not flatpak_id:
            return False

        try:
            result = subprocess.run(
                ["flatpak", "install", "-y", "flathub", flatpak_id],
                capture_output=True,
                text=True,
                timeout=600,
            )
            return result.returncode == 0
        except Exception as e:
            print(f"Flatpak install error: {e}")
            return False

    def uninstall(self, app):
        flatpak_id = app.get("flatpak_id")
        if not flatpak_id:
            return False

        try:
            result = subprocess.run(
                ["flatpak", "uninstall", "-y", flatpak_id],
                capture_output=True,
                text=True,
                timeout=120,
            )
            return result.returncode == 0
        except Exception:
            return False
