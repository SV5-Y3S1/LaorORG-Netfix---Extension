# GitHub Release & Netlify Deployment Instructions

## Step 1: Create GitHub Release

1. Go to: https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension/releases

2. Click **"Create a new release"** or **"Draft a new release"**

3. Fill in:
   - **Tag version:** `v1.0.0`
   - **Release title:** `LaorORG Netfix v1.0.0`
   - **Description:**
     ```
     One-click extension installer for Netflix cookie injection.
     
     **Installation:**
     - Windows: Download install-extension.ps1
     - macOS/Linux: Download install-extension.sh
     - Manual: Download LaorORG-Netfix-Extension.zip
     
     Or visit: https://laororg-netfix.netlify.app/
     ```

4. **Attach files** (drag & drop or click "Attach"):
   - `LaorORG-Netfix-Extension.zip`
   - `install-extension.ps1`
   - `install-extension.sh`

5. Click **"Publish release"**

---

## Step 2: Deploy to Netlify

### Method A: Auto-Connect (Recommended)

1. Go to: https://app.netlify.com/start

2. Click **"Connect to Git"**

3. Select **"GitHub"**

4. Search for: `LaorORG-Netfix---Extension`

5. Click to connect

6. Build settings (defaults should be fine):
   - **Build command:** (leave empty or: `echo 'Static site - no build'`)
   - **Publish directory:** `.` (root)

7. Click **"Deploy site"**

8. Your site is live at: `https://[random-name].netlify.app`

9. (Optional) Go to **Site settings** → **Domain management** → **Add custom domain** for: `laororg-netfix.netlify.app`

---

### Method B: Manual Deploy (Drag & Drop)

1. Go to: https://app.netlify.com

2. Sign in (create account if needed)

3. Drag the `D:\LaorORG-Netfix-Clean` folder into Netlify

4. Your site deploys instantly

---

## Step 3: Verify Deployment

- Check: `https://laororg-netfix.netlify.app/`
- Should show the one-click installer
- Test button clicks to verify downloads work

---

## Update Installation Links

Once deployed, the web installer is live and users can access it at:

```
👉 https://laororg-netfix.netlify.app/
```

Share this link with users!

