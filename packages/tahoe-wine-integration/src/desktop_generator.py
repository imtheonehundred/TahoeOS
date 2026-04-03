import os
from pathlib import Path


class DesktopGenerator:
    def __init__(self):
        self.desktop_dir = Path.home() / ".local" / "share" / "applications"
        self.desktop_dir.mkdir(parents=True, exist_ok=True)

    def create(
        self, app_name, exe_path, prefix, icon=None, wine_env=None, categories=None
    ):
        desktop_id = f"wine-{app_name.lower().replace(' ', '-')}"
        desktop_file = self.desktop_dir / f"{desktop_id}.desktop"

        if categories is None:
            categories = ["Application", "Wine"]

        exec_cmd = self._build_exec_command(exe_path, prefix, wine_env)

        icon_value = str(icon) if icon else "application-x-ms-dos-executable"

        content = f"""[Desktop Entry]
Type=Application
Name={app_name}
Comment=Windows application running via Wine
Exec={exec_cmd}
Icon={icon_value}
Categories={";".join(categories)};
Terminal=false
StartupNotify=true
StartupWMClass={app_name.lower()}
X-TahoeOS-Wine=true
X-TahoeOS-Prefix={prefix}
X-TahoeOS-Exe={exe_path}
"""

        with open(desktop_file, "w") as f:
            f.write(content)

        os.chmod(desktop_file, 0o755)

        self._update_desktop_database()

        return desktop_file

    def _build_exec_command(self, exe_path, prefix, wine_env=None):
        cmd_parts = []

        cmd_parts.append(f'env WINEPREFIX="{prefix}"')

        if wine_env:
            if wine_env.get("MANGOHUD"):
                cmd_parts.insert(0, "mangohud")
            if wine_env.get("GAMEMODE"):
                cmd_parts.insert(0, "gamemoderun")

        cmd_parts.append("wine")
        cmd_parts.append(f'"{exe_path}"')

        return " ".join(cmd_parts)

    def _update_desktop_database(self):
        try:
            import subprocess

            subprocess.run(
                ["update-desktop-database", str(self.desktop_dir)],
                capture_output=True,
                timeout=10,
            )
        except Exception:
            pass

    def remove(self, app_name):
        desktop_id = f"wine-{app_name.lower().replace(' ', '-')}"
        desktop_file = self.desktop_dir / f"{desktop_id}.desktop"

        if desktop_file.exists():
            desktop_file.unlink()
            self._update_desktop_database()
            return True

        return False

    def list_wine_apps(self):
        apps = []

        for desktop_file in self.desktop_dir.glob("wine-*.desktop"):
            try:
                with open(desktop_file, "r") as f:
                    content = f.read()

                app_info = {"desktop_file": str(desktop_file)}

                for line in content.split("\n"):
                    if line.startswith("Name="):
                        app_info["name"] = line.split("=", 1)[1]
                    elif line.startswith("Icon="):
                        app_info["icon"] = line.split("=", 1)[1]
                    elif line.startswith("X-TahoeOS-Prefix="):
                        app_info["prefix"] = line.split("=", 1)[1]
                    elif line.startswith("X-TahoeOS-Exe="):
                        app_info["exe"] = line.split("=", 1)[1]

                if "name" in app_info:
                    apps.append(app_info)
            except Exception:
                pass

        return apps
