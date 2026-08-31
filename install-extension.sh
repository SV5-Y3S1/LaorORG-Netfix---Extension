#!/bin/bash

# LaorORG © Netfix Extension Auto-Installer (macOS/Linux)
# Downloads and auto-loads the Netflix cookie injector into Chrome

set -e

BROWSER="${1:-chrome}"
EXTENSION_URL="${2:-https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension/releases/download/v1.0.0/LaorORG-Netfix-Extension.zip}"

TEMP_DIR="/tmp/LaorORG-Netfix-Installer"
EXTRACT_PATH="$HOME/.local/share/LaorORG-Netfix-Extension"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    CHROME_EXE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    EDGE_EXE="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
else
    OS="Linux"
    CHROME_EXE="google-chrome"
    EDGE_EXE="microsoft-edge"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         LaorORG © Netfix Extension Auto-Installer            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Select browser executable
if [ "$BROWSER" = "edge" ]; then
    BROWSER_EXE="$EDGE_EXE"
    BROWSER_NAME="Microsoft Edge"
else
    BROWSER_EXE="$CHROME_EXE"
    BROWSER_NAME="Google Chrome"
fi

echo "→ Installing for $BROWSER_NAME ($OS)"

# Check if browser is installed
if ! command -v "$BROWSER_EXE" &> /dev/null; then
    echo "✗ $BROWSER_NAME not found at: $BROWSER_EXE"
    exit 1
fi
echo "✓ $BROWSER_NAME found"

# Create temp directory
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
echo "✓ Temp directory created"

# Download extension
echo "→ Downloading extension from GitHub..."
ZIP_PATH="$TEMP_DIR/extension.zip"
curl -L -o "$ZIP_PATH" "$EXTENSION_URL" --progress-bar
echo "✓ Downloaded $(du -h "$ZIP_PATH" | cut -f1)"

# Extract extension
echo "→ Extracting extension..."
rm -rf "$EXTRACT_PATH"
mkdir -p "$EXTRACT_PATH"
unzip -q "$ZIP_PATH" -d "$TEMP_DIR"

# Move extracted files
if ls "$TEMP_DIR"/*/manifest.json 1> /dev/null 2>&1; then
    cp -r "$TEMP_DIR"/*/. "$EXTRACT_PATH/"
else
    cp -r "$TEMP_DIR"/* "$EXTRACT_PATH/"
fi
echo "✓ Extracted to $EXTRACT_PATH"

# Verify manifest
if [ ! -f "$EXTRACT_PATH/manifest.json" ]; then
    echo "✗ manifest.json not found in extracted extension"
    exit 1
fi
echo "✓ Manifest verified"

# Launch browser with extension
echo "→ Launching $BROWSER_NAME..."
if [ "$OS" = "macOS" ]; then
    open -a "$BROWSER_NAME" --args "--load-extension=$EXTRACT_PATH" "https://www.netflix.com" &
else
    "$BROWSER_EXE" "--load-extension=$EXTRACT_PATH" "https://www.netflix.com" &
fi
sleep 2
echo "✓ $BROWSER_NAME launched with extension"

# Cleanup
rm -rf "$TEMP_DIR"
echo "✓ Temp files cleaned up"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    Installation Complete!                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "Extension location: $EXTRACT_PATH"
echo ""
echo "Next steps:"
echo "1. $BROWSER_NAME is launching with the extension loaded"
echo "2. Go to chrome://extensions/ (or edge://extensions/) to verify"
echo "3. Click the LaorORG © Netfix icon to inject your Netflix cookie"
echo ""
echo "To modify the cookie:"
echo "1. Edit: $EXTRACT_PATH/popup.js"
echo "2. Find: const SAVED_COOKIES = ["
echo "3. Update the 'value' field with your Netflix nfvdid cookie"
echo "4. Reload the extension in chrome://extensions/"
echo ""
