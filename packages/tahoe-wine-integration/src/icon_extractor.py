import subprocess
import tempfile
import os
from pathlib import Path


class IconExtractor:
    def __init__(self):
        self.icons_dir = Path.home() / ".local" / "share" / "icons" / "tahoeos-wine"
        self.icons_dir.mkdir(parents=True, exist_ok=True)

    def extract(self, exe_path, app_name):
        exe_path = Path(exe_path)

        if not exe_path.exists():
            return None

        icon_name = app_name.lower().replace(" ", "-")
        output_path = self.icons_dir / f"{icon_name}.png"

        methods = [
            self._extract_with_wrestool,
            self._extract_with_icoextract,
            self._extract_with_7z,
        ]

        for method in methods:
            try:
                result = method(exe_path, output_path)
                if result and output_path.exists():
                    return output_path
            except Exception:
                continue

        return None

    def _extract_with_wrestool(self, exe_path, output_path):
        with tempfile.TemporaryDirectory() as tmpdir:
            ico_path = Path(tmpdir) / "icon.ico"

            result = subprocess.run(
                [
                    "wrestool",
                    "-x",
                    "-t",
                    "group_icon",
                    "-o",
                    str(ico_path),
                    str(exe_path),
                ],
                capture_output=True,
                timeout=30,
            )

            if ico_path.exists():
                subprocess.run(
                    [
                        "convert",
                        f"{ico_path}[0]",
                        "-resize",
                        "256x256",
                        str(output_path),
                    ],
                    capture_output=True,
                    timeout=30,
                )

                if output_path.exists():
                    return True

        return False

    def _extract_with_icoextract(self, exe_path, output_path):
        with tempfile.TemporaryDirectory() as tmpdir:
            ico_path = Path(tmpdir) / "icon.ico"

            result = subprocess.run(
                ["icoextract", str(exe_path), str(ico_path)],
                capture_output=True,
                timeout=30,
            )

            if ico_path.exists():
                subprocess.run(
                    [
                        "convert",
                        f"{ico_path}[0]",
                        "-resize",
                        "256x256",
                        str(output_path),
                    ],
                    capture_output=True,
                    timeout=30,
                )

                if output_path.exists():
                    return True

        return False

    def _extract_with_7z(self, exe_path, output_path):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = subprocess.run(
                ["7z", "e", str(exe_path), "-o" + tmpdir, "*.ico", "-r"],
                capture_output=True,
                timeout=60,
            )

            ico_files = list(Path(tmpdir).glob("*.ico"))
            if ico_files:
                ico_path = max(ico_files, key=lambda f: f.stat().st_size)

                subprocess.run(
                    [
                        "convert",
                        f"{ico_path}[0]",
                        "-resize",
                        "256x256",
                        str(output_path),
                    ],
                    capture_output=True,
                    timeout=30,
                )

                if output_path.exists():
                    return True

        return False

    def get_icon_for_app(self, app_name):
        icon_name = app_name.lower().replace(" ", "-")
        icon_path = self.icons_dir / f"{icon_name}.png"

        if icon_path.exists():
            return icon_path

        return None
