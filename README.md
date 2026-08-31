# LaorORG © Netfix – One-Click Extension Installer

Auto-install the Netflix cookie injector extension with one click. No configuration needed.

## 🚀 Quick Install

**Click to install:**
👉 **[Install Now](https://laororg-netfix.netlify.app/)**

Select your browser (Chrome or Edge) and click "Install Extension". The extension loads automatically.

---

## 📦 What's Included

- **Web Installer** – One-click auto-download & install
- **PowerShell Script** – Windows auto-installer (Admin)
- **Bash Script** – macOS/Linux auto-installer
- **Manual ZIP** – Download and load unpacked

---

## 🔧 How It Works

1. Visit the installer link
2. Select Chrome or Edge (auto-detected)
3. Click "Install Extension"
4. Installer downloads for your OS
5. Run it, extension auto-loads
6. Done! Click the icon to inject cookies

---

## 📝 Manual Installation

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File install-extension.ps1 -Browser Chrome
```

**macOS/Linux (Bash):**
```bash
chmod +x install-extension.sh && ./install-extension.sh chrome
```

**Manual ZIP:**
- Download `LaorORG-Netfix-Extension.zip`
- Extract anywhere
- Open `chrome://extensions/`
- Enable Developer mode
- Click "Load unpacked"
- Select extracted folder

---

## 🎯 Modifying Your Cookie

1. Extract the ZIP file
2. Edit `popup.js`
3. Find: `const SAVED_COOKIES = [`
4. Update the `value` field with your Netflix `nfvdid` cookie
5. Reload extension in `chrome://extensions/`

---

## ⚠️ Legal Notice

Using unauthorized Netflix cookies may violate their Terms of Service. Use only on accounts you own, for personal testing or session recovery.

---

## 📄 License

MIT © 2026 LaorORG

**Repository:** [SV5-Y3S1/LaorORG-Netfix---Extension](https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension)

