import subprocess
import json
import os
import requests
from pathlib import Path


class AppImageBackend:
    def __init__(self):
        self.appimage_dir = Path.home() / "Applications"
        self.appimage_dir.mkdir(parents=True, exist_ok=True)
        self.cache_file = (
            Path.home() / ".cache" / "tahoe-app-store" / "appimage_cache.json"
        )
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)
        self.registry_file = (
            Path.home() / ".local" / "share" / "tahoeos" / "appimages.json"
        )
        self.registry_file.parent.mkdir(parents=True, exist_ok=True)

    def get_apps(self):
        apps = []

        installed = self._get_installed_appimages()
        for app_info in installed:
            apps.append(
                {
                    "id": f"appimage:{app_info['id']}",
                    "name": app_info["name"],
                    "version": app_info.get("version", ""),
                    "description": "AppImage application",
                    "icon": app_info.get("icon", "application-x-executable-symbolic"),
                    "source": "appimage",
                    "installed": True,
                    "appimage_path": app_info.get("path"),
                    "desktop_file": app_info.get("desktop_file"),
                    "categories": app_info.get("categories", []),
                }
            )

        popular = self._get_popular_appimages()
        for app_info in popular:
            if not any(a["name"].lower() == app_info["name"].lower() for a in apps):
                apps.append(
                    {
                        "id": f"appimage:{app_info['id']}",
                        "name": app_info["name"],
                        "version": app_info.get("version", ""),
                        "description": app_info.get(
                            "description", "AppImage application"
                        ),
                        "icon": "application-x-executable-symbolic",
                        "source": "appimage",
                        "installed": False,
                        "download_url": app_info.get("download_url"),
                        "github_repo": app_info.get("github_repo"),
                        "categories": app_info.get("categories", []),
                    }
                )

        return apps

    def _get_installed_appimages(self):
        apps = []

        search_dirs = [
            self.appimage_dir,
            Path.home() / "Downloads",
            Path.home() / ".local" / "bin",
        ]

        for search_dir in search_dirs:
            if not search_dir.exists():
                continue

            for appimage in search_dir.glob("*.AppImage"):
                app_id = appimage.stem.lower().replace(" ", "-")
                name = appimage.stem

                if "-" in name and name.split("-")[-1].replace(".", "").isdigit():
                    version = name.split("-")[-1]
                    name = "-".join(name.split("-")[:-1])
                else:
                    version = ""

                desktop_file = self._find_desktop_for_appimage(appimage)
                icon = self._extract_icon(appimage) if not desktop_file else None

                apps.append(
                    {
                        "id": app_id,
                        "name": name,
                        "version": version,
                        "path": str(appimage),
                        "desktop_file": desktop_file,
                        "icon": icon,
                    }
                )

        if self.registry_file.exists():
            try:
                with open(self.registry_file, "r") as f:
                    registry = json.load(f)
                    for app_id, info in registry.items():
                        if not any(a["id"] == app_id for a in apps):
                            if os.path.exists(info.get("path", "")):
                                apps.append(
                                    {
                                        "id": app_id,
                                        "name": info.get("name", app_id),
                                        "version": info.get("version", ""),
                                        "path": info.get("path"),
                                        "desktop_file": info.get("desktop_file"),
                                        "icon": info.get("icon"),
                                    }
                                )
            except Exception:
                pass

        return apps

    def _find_desktop_for_appimage(self, appimage_path):
        name = appimage_path.stem.lower()
        desktop_dir = Path.home() / ".local" / "share" / "applications"

        if desktop_dir.exists():
            for desktop_file in desktop_dir.glob("*.desktop"):
                if name in desktop_file.stem.lower():
                    return str(desktop_file)
                try:
                    with open(desktop_file, "r") as f:
                        content = f.read()
                        if str(appimage_path) in content:
                            return str(desktop_file)
                except Exception:
                    pass

        return None

    def _extract_icon(self, appimage_path):
        return "application-x-executable-symbolic"

    def _get_popular_appimages(self):
        return [
            {
                "id": "balena-etcher",
                "name": "balenaEtcher",
                "description": "Flash OS images to SD cards & USB drives",
                "github_repo": "balena-io/etcher",
                "categories": ["Utility"],
            },
            {
                "id": "appimage-launcher",
                "name": "AppImageLauncher",
                "description": "Integrate AppImages into your system",
                "github_repo": "TheAssassin/AppImageLauncher",
                "categories": ["Utility"],
            },
            {
                "id": "krita",
                "name": "Krita",
                "description": "Digital painting application",
                "github_repo": "KDE/krita",
                "categories": ["Graphics"],
            },
            {
                "id": "musescore",
                "name": "MuseScore",
                "description": "Music notation software",
                "github_repo": "musescore/MuseScore",
                "categories": ["Audio"],
            },
            {
                "id": "freecad",
                "name": "FreeCAD",
                "description": "Parametric 3D CAD modeler",
                "github_repo": "FreeCAD/FreeCAD",
                "categories": ["Graphics"],
            },
            {
                "id": "openshot",
                "name": "OpenShot",
                "description": "Video editor",
                "github_repo": "OpenShot/openshot-qt",
                "categories": ["Video"],
            },
            {
                "id": "subsurface",
                "name": "Subsurface",
                "description": "Dive log software",
                "github_repo": "subsurface/subsurface",
                "categories": ["Utility"],
            },
            {
                "id": "appflowy",
                "name": "AppFlowy",
                "description": "Open-source Notion alternative",
                "github_repo": "AppFlowy-IO/AppFlowy",
                "categories": ["Office"],
            },
            {
                "id": "logseq",
                "name": "Logseq",
                "description": "Knowledge management",
                "github_repo": "logseq/logseq",
                "categories": ["Office"],
            },
            {
                "id": "joplin",
                "name": "Joplin",
                "description": "Note taking application",
                "github_repo": "laurent22/joplin",
                "categories": ["Office"],
            },
        ]

    def install(self, app):
        github_repo = app.get("github_repo")
        download_url = app.get("download_url")

        if github_repo:
            download_url = self._get_github_release_url(github_repo)

        if not download_url:
            return False

        try:
            filename = download_url.split("/")[-1]
            if not filename.endswith(".AppImage"):
                filename = f"{app.get('name', 'app')}.AppImage"

            dest_path = self.appimage_dir / filename

            response = requests.get(download_url, stream=True, timeout=300)
            response.raise_for_status()

            with open(dest_path, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            os.chmod(dest_path, 0o755)

            self._create_desktop_entry(app, dest_path)

            self._update_registry(app, dest_path)

            return True
        except Exception as e:
            print(f"AppImage install error: {e}")
            return False

    def _get_github_release_url(self, repo):
        try:
            api_url = f"https://api.github.com/repos/{repo}/releases/latest"
            response = requests.get(api_url, timeout=30)
            response.raise_for_status()
            release = response.json()

            for asset in release.get("assets", []):
                name = asset.get("name", "").lower()
                if name.endswith(".appimage") and "x86_64" in name:
                    return asset.get("browser_download_url")

            for asset in release.get("assets", []):
                if asset.get("name", "").lower().endswith(".appimage"):
                    return asset.get("browser_download_url")
        except Exception:
            pass
        return None

    def _create_desktop_entry(self, app, appimage_path):
        desktop_dir = Path.home() / ".local" / "share" / "applications"
        desktop_dir.mkdir(parents=True, exist_ok=True)

        app_name = app.get("name", appimage_path.stem)
        desktop_file = (
            desktop_dir / f"appimage-{app_name.lower().replace(' ', '-')}.desktop"
        )

        content = f"""[Desktop Entry]
Type=Application
Name={app_name}
Exec="{appimage_path}"
Icon=application-x-executable
Categories=Utility;
Terminal=false
"""

        with open(desktop_file, "w") as f:
            f.write(content)

        os.chmod(desktop_file, 0o755)

    def _update_registry(self, app, appimage_path):
        registry = {}
        if self.registry_file.exists():
            try:
                with open(self.registry_file, "r") as f:
                    registry = json.load(f)
            except Exception:
                pass

        app_id = app.get("id", "").replace("appimage:", "")
        registry[app_id] = {
            "name": app.get("name"),
            "version": app.get("version", ""),
            "path": str(appimage_path),
            "installed_at": str(Path(appimage_path).stat().st_mtime),
        }

        with open(self.registry_file, "w") as f:
            json.dump(registry, f, indent=2)

    def uninstall(self, app):
        appimage_path = app.get("appimage_path")
        if appimage_path and os.path.exists(appimage_path):
            try:
                os.remove(appimage_path)

                desktop_file = app.get("desktop_file")
                if desktop_file and os.path.exists(desktop_file):
                    os.remove(desktop_file)

                return True
            except Exception:
                pass
        return False

    def launch(self, app):
        appimage_path = app.get("appimage_path")
        if appimage_path and os.path.exists(appimage_path):
            try:
                subprocess.Popen([appimage_path])
                return True
            except Exception:
                pass
        return False
