# Update Netlify Deployment to Latest Repository

Your Netlify site is deployed but may be pointing to an old repository. Here's how to reconnect it to your updated GitHub repo:

## Step 1: Go to Netlify Dashboard

1. Visit: https://app.netlify.com
2. Sign in with your GitHub account
3. Find the site: `laororg-netfix-extension`
4. Click on it

## Step 2: Check Connected Repository

1. Go to **Site settings** (left menu)
2. Click **Build & deploy** → **Repository**
3. You should see a connected GitHub repo
4. If it's pointing to the wrong repo, proceed to Step 3

## Step 3: Reconnect to Correct Repository

1. Click **Connected to GitHub** button
2. Select **Disconnect** (if needed)
3. Click **Connect to Git** 
4. Choose **GitHub**
5. Search for: `SV5-Y3S1/LaorORG-Netfix---Extension`
6. Click **Deploy**

## Step 4: Verify Deployment

1. Go to **Deploys** tab
2. Wait for new build (watch the progress)
3. Once complete, click the **Preview** URL
4. Should see the updated installer with:
   - ✓ Logo from `icons/icon128.png`
   - ✓ "Download & Install" button
   - ✓ Python auto-installer

## Step 5: Test the Live Site

Visit: https://laororg-netfix-extension.netlify.app/

- Select Chrome or Edge
- Click "Download & Install"
- Verify `install-extension.py` downloads

---

## Alternative: Manual Rebuild

If the site is already connected to your repo:

1. Go to **Deploys** tab
2. Click **Trigger deploy** → **Deploy site**
3. Netlify will pull latest code from GitHub and rebuild
4. Site updates automatically (1-2 minutes)

---

## If Still Not Working

1. Check **Deploy logs** for errors
2. Verify `netlify.toml` exists in repo root (it should)
3. Try **Clear cache and redeploy**
4. Contact Netlify support if deployment keeps failing

---

**Repository:** https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension  
**Live Site:** https://laororg-netfix-extension.netlify.app/

