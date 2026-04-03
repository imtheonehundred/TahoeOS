import subprocess
import os
from pathlib import Path


class PrefixManager:
    def __init__(self, prefixes_dir):
        self.prefixes_dir = Path(prefixes_dir)
        self.prefixes_dir.mkdir(parents=True, exist_ok=True)

    def get_or_create_prefix(self, name):
        prefix = self.prefixes_dir / name

        if not prefix.exists():
            self.create_prefix(prefix)

        return prefix

    def create_prefix(self, prefix):
        prefix.mkdir(parents=True, exist_ok=True)

        env = os.environ.copy()
        env["WINEPREFIX"] = str(prefix)
        env["WINEARCH"] = "win64"

        try:
            subprocess.run(
                ["wineboot", "--init"], env=env, capture_output=True, timeout=120
            )
        except Exception as e:
            print(f"Prefix init error: {e}")

        return prefix

    def setup_prefix(self, prefix, dxvk=True, vkd3d=True):
        env = os.environ.copy()
        env["WINEPREFIX"] = str(prefix)

        if dxvk:
            self._setup_dxvk(prefix, env)

        if vkd3d:
            self._setup_vkd3d(prefix, env)

        self._install_common_components(prefix, env)

    def _setup_dxvk(self, prefix, env):
        try:
            subprocess.run(
                ["winetricks", "-q", "dxvk"], env=env, capture_output=True, timeout=300
            )
        except Exception as e:
            print(f"DXVK setup error: {e}")

            dxvk_paths = ["/usr/share/dxvk/x64", "/usr/lib64/dxvk", "/usr/lib/dxvk"]

            system32 = prefix / "drive_c" / "windows" / "system32"

            for dxvk_path in dxvk_paths:
                if os.path.exists(dxvk_path):
                    for dll in ["d3d9.dll", "d3d10core.dll", "d3d11.dll", "dxgi.dll"]:
                        src = Path(dxvk_path) / dll
                        dst = system32 / dll
                        if src.exists():
                            try:
                                if dst.exists():
                                    dst.unlink()
                                os.symlink(src, dst)
                            except Exception:
                                pass
                    break

    def _setup_vkd3d(self, prefix, env):
        try:
            subprocess.run(
                ["winetricks", "-q", "vkd3d"], env=env, capture_output=True, timeout=300
            )
        except Exception as e:
            print(f"VKD3D setup error: {e}")

    def _install_common_components(self, prefix, env):
        components = ["corefonts", "vcrun2019", "dotnet48"]

        for component in components:
            try:
                subprocess.run(
                    ["winetricks", "-q", component],
                    env=env,
                    capture_output=True,
                    timeout=600,
                )
            except Exception:
                pass

    def list_prefixes(self):
        prefixes = []
        for item in self.prefixes_dir.iterdir():
            if item.is_dir() and (item / "drive_c").exists():
                prefixes.append(item.name)
        return prefixes

    def delete_prefix(self, name):
        prefix = self.prefixes_dir / name
        if prefix.exists():
            import shutil

            shutil.rmtree(prefix)
            return True
        return False
