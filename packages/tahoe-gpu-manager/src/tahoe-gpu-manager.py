#!/usr/bin/env python3
import subprocess
import sys


def detect_gpu():
    try:
        lspci = subprocess.check_output(["lspci", "-nn"], text=True)
        gpus = []
        for line in lspci.split("\n"):
            if "VGA" in line or "3D" in line or "Display" in line:
                if "NVIDIA" in line.upper():
                    gpus.append(("nvidia", line))
                elif "AMD" in line.upper() or "ATI" in line.upper():
                    gpus.append(("amd", line))
                elif "INTEL" in line.upper():
                    gpus.append(("intel", line))
        return gpus
    except:
        return []


def install_nvidia():
    print("Installing NVIDIA drivers...")
    subprocess.run(
        ["dnf", "install", "-y", "akmod-nvidia", "xorg-x11-drv-nvidia-cuda"], check=True
    )
    print("NVIDIA drivers installed. Reboot required.")


def install_amd():
    print("AMD drivers are included in kernel. Checking for firmware...")
    subprocess.run(
        [
            "dnf",
            "install",
            "-y",
            "mesa-dri-drivers",
            "mesa-vulkan-drivers",
            "xorg-x11-drv-amdgpu",
        ],
        check=True,
    )
    print("AMD drivers ready.")


def main():
    print("TahoeOS GPU Manager")
    print("=" * 40)

    gpus = detect_gpu()
    if not gpus:
        print("No discrete GPU detected.")
        return

    for vendor, info in gpus:
        print(f"Found: {info[:60]}...")

        if vendor == "nvidia":
            if (
                "--auto" in sys.argv
                or input("Install NVIDIA drivers? [y/N] ").lower() == "y"
            ):
                install_nvidia()
        elif vendor == "amd":
            if (
                "--auto" in sys.argv
                or input("Install AMD drivers? [y/N] ").lower() == "y"
            ):
                install_amd()
        elif vendor == "intel":
            print("Intel GPU - drivers included in kernel.")


if __name__ == "__main__":
    main()
