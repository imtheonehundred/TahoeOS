import subprocess
import json
import os
from pathlib import Path


class WineBackend:
    def __init__(self):
        self.wine_apps_dir = Path.home() / ".local" / "share" / "tahoeos" / "wine-apps"
        self.wine_apps_dir.mkdir(parents=True, exist_ok=True)
        self.cache_file = Path.home() / ".cache" / "tahoe-app-store" / "wine_cache.json"
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)

    def get_apps(self):
        apps = []

        installed = self._get_installed_wine_apps()
        for app_info in installed:
            apps.append(
                {
                    "id": f"wine:{app_info['id']}",
                    "name": app_info["name"],
                    "version": app_info.get("version", ""),
                    "description": "Windows application",
                    "icon": app_info.get(
                        "icon", "application-x-ms-dos-executable-symbolic"
                    ),
                    "source": "wine",
                    "installed": True,
                    "prefix": app_info.get("prefix"),
                    "exe_path": app_info.get("exe_path"),
                    "desktop_file": app_info.get("desktop_file"),
                    "categories": ["Game"] if app_info.get("is_game") else [],
                }
            )

        popular = self._get_popular_windows_apps()
        for app_info in popular:
            if not any(a["name"].lower() == app_info["name"].lower() for a in apps):
                apps.append(
                    {
                        "id": f"wine:{app_info['id']}",
                        "name": app_info["name"],
                        "version": "",
                        "description": app_info.get(
                            "description", "Windows application"
                        ),
                        "icon": "application-x-ms-dos-executable-symbolic",
                        "source": "wine",
                        "installed": False,
                        "installer_url": app_info.get("installer_url"),
                        "use_bottles": app_info.get("use_bottles", False),
                        "use_lutris": app_info.get("use_lutris", False),
                        "lutris_slug": app_info.get("lutris_slug"),
                        "categories": app_info.get("categories", []),
                    }
                )

        return apps

    def _get_installed_wine_apps(self):
        apps = []

        desktop_dir = Path.home() / ".local" / "share" / "applications"
        if desktop_dir.exists():
            for desktop_file in desktop_dir.glob("wine-*.desktop"):
                app_info = self._parse_wine_desktop(desktop_file)
                if app_info:
                    apps.append(app_info)

        registry_file = self.wine_apps_dir / "installed.json"
        if registry_file.exists():
            try:
                with open(registry_file, "r") as f:
                    registry = json.load(f)
                    for app_id, info in registry.items():
                        if not any(a.get("id") == app_id for a in apps):
                            apps.append(
                                {
                                    "id": app_id,
                                    "name": info.get("name", app_id),
                                    "prefix": info.get("prefix"),
                                    "exe_path": info.get("exe_path"),
                                    "icon": info.get("icon"),
                                    "is_game": info.get("is_game", False),
                                }
                            )
            except Exception:
                pass

        bottles_apps = self._get_bottles_apps()
        apps.extend(bottles_apps)

        lutris_apps = self._get_lutris_apps()
        apps.extend(lutris_apps)

        return apps

    def _parse_wine_desktop(self, desktop_file):
        try:
            with open(desktop_file, "r") as f:
                content = f.read()

            info = {"id": desktop_file.stem, "desktop_file": str(desktop_file)}

            for line in content.split("\n"):
                if line.startswith("Name="):
                    info["name"] = line.split("=", 1)[1]
                elif line.startswith("Icon="):
                    info["icon"] = line.split("=", 1)[1]
                elif line.startswith("Exec="):
                    exec_line = line.split("=", 1)[1]
                    if "wine" in exec_line.lower():
                        info["exe_path"] = exec_line

            if "name" in info:
                return info
        except Exception:
            pass
        return None

    def _get_bottles_apps(self):
        apps = []
        bottles_dir = Path.home() / ".local" / "share" / "bottles" / "bottles"

        if bottles_dir.exists():
            for bottle in bottles_dir.iterdir():
                if bottle.is_dir():
                    programs_file = bottle / "programs.json"
                    if programs_file.exists():
                        try:
                            with open(programs_file, "r") as f:
                                programs = json.load(f)
                                for prog_id, prog_info in programs.items():
                                    apps.append(
                                        {
                                            "id": f"bottles-{bottle.name}-{prog_id}",
                                            "name": prog_info.get("name", prog_id),
                                            "prefix": str(bottle),
                                            "exe_path": prog_info.get("path"),
                                            "is_game": "game" in bottle.name.lower(),
                                        }
                                    )
                        except Exception:
                            pass

        return apps

    def _get_lutris_apps(self):
        apps = []
        lutris_db = Path.home() / ".local" / "share" / "lutris" / "pga.db"

        if lutris_db.exists():
            try:
                import sqlite3

                conn = sqlite3.connect(str(lutris_db))
                cursor = conn.cursor()
                cursor.execute(
                    "SELECT slug, name, runner, directory FROM games WHERE installed = 1"
                )
                for row in cursor.fetchall():
                    slug, name, runner, directory = row
                    if runner in ["wine", "dxvk", "vkd3d"]:
                        apps.append(
                            {
                                "id": f"lutris-{slug}",
                                "name": name,
                                "prefix": directory,
                                "is_game": True,
                            }
                        )
                conn.close()
            except Exception:
                pass

        return apps

    def _get_popular_windows_apps(self):
        return [
            {
                "id": "league-of-legends",
                "name": "League of Legends",
                "description": "MOBA game by Riot Games",
                "use_lutris": True,
                "lutris_slug": "league-of-legends",
                "categories": ["Game"],
            },
            {
                "id": "genshin-impact",
                "name": "Genshin Impact",
                "description": "Action RPG by miHoYo",
                "use_lutris": True,
                "lutris_slug": "genshin-impact",
                "categories": ["Game"],
            },
            {
                "id": "overwatch-2",
                "name": "Overwatch 2",
                "description": "Team shooter by Blizzard",
                "use_lutris": True,
                "lutris_slug": "overwatch-2",
                "categories": ["Game"],
            },
            {
                "id": "valorant",
                "name": "Valorant",
                "description": "Tactical shooter (requires VM)",
                "use_lutris": True,
                "lutris_slug": "valorant",
                "categories": ["Game"],
            },
            {
                "id": "battle-net",
                "name": "Battle.net",
                "description": "Blizzard game launcher",
                "use_bottles": True,
                "categories": ["Game"],
            },
            {
                "id": "epic-games",
                "name": "Epic Games Launcher",
                "description": "Epic Games store",
                "use_bottles": True,
                "categories": ["Game"],
            },
            {
                "id": "gog-galaxy",
                "name": "GOG Galaxy",
                "description": "GOG game launcher",
                "use_bottles": True,
                "categories": ["Game"],
            },
            {
                "id": "origin",
                "name": "EA App",
                "description": "EA game launcher",
                "use_bottles": True,
                "categories": ["Game"],
            },
            {
                "id": "photoshop",
                "name": "Adobe Photoshop",
                "description": "Image editing (via Bottles)",
                "use_bottles": True,
                "categories": ["Graphics"],
            },
            {
                "id": "office365",
                "name": "Microsoft Office",
                "description": "Office suite (via Bottles)",
                "use_bottles": True,
                "categories": ["Office"],
            },
        ]

    def install(self, app):
        if app.get("use_lutris") and app.get("lutris_slug"):
            return self._install_via_lutris(app)
        elif app.get("use_bottles"):
            return self._install_via_bottles(app)
        elif app.get("installer_url"):
            return self._install_direct(app)
        return False

    def _install_via_lutris(self, app):
        slug = app.get("lutris_slug")
        try:
            result = subprocess.run(
                ["lutris", f"lutris:{slug}"], capture_output=True, text=True, timeout=10
            )
            return True
        except Exception as e:
            print(f"Lutris launch error: {e}")
            return False

    def _install_via_bottles(self, app):
        try:
            subprocess.run(["flatpak", "run", "com.usebottles.bottles"], timeout=5)
            return True
        except Exception:
            try:
                subprocess.run(["bottles"], timeout=5)
                return True
            except Exception:
                return False

    def _install_direct(self, app):
        return False

    def launch(self, app):
        desktop_file = app.get("desktop_file")
        if desktop_file and os.path.exists(desktop_file):
            try:
                subprocess.Popen(["gtk-launch", Path(desktop_file).stem])
                return True
            except Exception:
                pass

        exe_path = app.get("exe_path")
        prefix = app.get("prefix")
        if exe_path:
            env = os.environ.copy()
            if prefix:
                env["WINEPREFIX"] = prefix
            try:
                subprocess.Popen(["wine", exe_path], env=env)
                return True
            except Exception:
                pass

        return False
