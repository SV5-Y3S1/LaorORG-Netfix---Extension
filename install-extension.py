#!/usr/bin/env python3
"""
LaorORG Netfix Extension Auto-Installer
Downloads and automatically loads extension into Chrome/Edge
Works on Windows, macOS, Linux
"""

import os
import sys
import json
import shutil
import zipfile
import subprocess
import platform
from pathlib import Path
from urllib.request import urlretrieve

# Configuration
EXTENSION_ZIP_URL = "https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension/releases/download/v1.0.0/LaorORG-Netfix-Extension.zip"
BROWSER = sys.argv[1].lower() if len(sys.argv) > 1 else "chrome"
EXTRACT_DIR = Path.home() / ".local" / "share" / "LaorORG-Netfix-Extension"

def get_browser_paths():
    """Get browser executable and extension paths based on OS and browser"""
    system = platform.system()
    
    if system == "Windows":
        if BROWSER == "edge":
            exe = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
            ext_dir = Path.home() / "AppData" / "Local" / "Microsoft" / "Edge" / "User Data" / "Default" / "Extensions"
        else:
            exe = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
            ext_dir = Path.home() / "AppData" / "Local" / "Google" / "Chrome" / "User Data" / "Default" / "Extensions"
    
    elif system == "Darwin":  # macOS
        if BROWSER == "edge":
            exe = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
            ext_dir = Path.home() / "Library" / "Application Support" / "Microsoft Edge" / "Default" / "Extensions"
        else:
            exe = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
            ext_dir = Path.home() / "Library" / "Application Support" / "Google Chrome" / "Default" / "Extensions"
    
    else:  # Linux
        if BROWSER == "edge":
            exe = "/opt/microsoft/msedge/msedge"
            ext_dir = Path.home() / ".config" / "microsoft-edge" / "Default" / "Extensions"
        else:
            exe = "/usr/bin/google-chrome"
            ext_dir = Path.home() / ".config" / "google-chrome" / "Default" / "Extensions"
    
    return exe, ext_dir

def main():
    system = platform.system()
    browser_name = "Microsoft Edge" if BROWSER == "edge" else "Google Chrome"
    
    print("\n╔═══════════════════════════════════════════════════════════════╗")
    print("║         LaorORG © Netfix Extension Auto-Installer            ║")
    print("╚═══════════════════════════════════════════════════════════════╝\n")
    
    exe, ext_dir = get_browser_paths()
    
    # Check if browser exists
    if not os.path.exists(exe):
        print(f"✗ {browser_name} not found at: {exe}")
        sys.exit(1)
    
    print(f"✓ {browser_name} found")
    
    # Download extension
    print("→ Downloading extension...")
    try:
        zip_path = Path.home() / "Downloads" / "LaorORG-Netfix-Extension.zip"
        urlretrieve(EXTENSION_ZIP_URL, zip_path)
        print(f"✓ Downloaded ({os.path.getsize(zip_path) / 1024 / 1024:.1f} MB)")
    except Exception as e:
        print(f"✗ Download failed: {e}")
        sys.exit(1)
    
    # Extract extension
    print("→ Extracting extension...")
    try:
        os.makedirs(EXTRACT_DIR, exist_ok=True)
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(EXTRACT_DIR)
        print(f"✓ Extracted to {EXTRACT_DIR}")
    except Exception as e:
        print(f"✗ Extraction failed: {e}")
        sys.exit(1)
    
    # Verify manifest
    if not (EXTRACT_DIR / "manifest.json").exists():
        print("✗ manifest.json not found")
        sys.exit(1)
    print("✓ Extension verified")
    
    # Auto-launch browser with extension
    print(f"→ Launching {browser_name}...")
    try:
        subprocess.Popen([exe, f"--load-extension={EXTRACT_DIR}", "https://www.netflix.com"])
        print(f"✓ {browser_name} launched with extension")
    except Exception as e:
        print(f"⚠ Could not auto-launch: {e}")
    
    print("\n╔═══════════════════════════════════════════════════════════════╗")
    print("║                    Installation Complete!                    ║")
    print("╚═══════════════════════════════════════════════════════════════╝\n")
    
    print(f"Extension location: {EXTRACT_DIR}")
    print(f"Verify: Open chrome://extensions/ or edge://extensions/")
    print("✓ The extension is ready to use!\n")

if __name__ == "__main__":
    main()
