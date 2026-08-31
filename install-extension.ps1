#Requires -RunAsAdministrator

<#
.SYNOPSIS
    LaorORG © Netfix Extension Auto-Installer
    
.DESCRIPTION
    Downloads and auto-loads the Netflix cookie injector extension into Chrome or Edge.
    Requires Administrator privileges.

.PARAMETER Browser
    Browser to install to: 'Chrome' or 'Edge' (default: 'Chrome')

.PARAMETER ExtensionUrl
    Direct URL to LaorORG-Netfix-Extension.zip
    Default: GitHub release URL

.EXAMPLE
    .\install-extension.ps1 -Browser Chrome
    .\install-extension.ps1 -Browser Edge
#>

param(
    [ValidateSet('Chrome', 'Edge')]
    [string]$Browser = 'Chrome',
    
    [string]$ExtensionUrl = "https://github.com/SV5-Y3S1/LaorORG-Netfix---Extension/releases/download/v1.0.0/LaorORG-Netfix-Extension.zip"
)

$ErrorActionPreference = "Stop"

# Paths
$tempDir = "$env:TEMP\LaorORG-Netfix-Installer"
$extractPath = "$env:LOCALAPPDATA\LaorORG-Netfix-Extension"
$zipPath = "$tempDir\extension.zip"

# Browser paths and registry keys
$browserPaths = @{
    'Chrome' = @{
        'Exe' = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
        'RegPath' = 'HKLM:\SOFTWARE\Policies\Google\Chrome'
        'RegPathUser' = 'HKCU:\Software\Google\Chrome\Extensions'
        'ExtKey' = 'nfvdid_cookie_injector'
    }
    'Edge' = @{
        'Exe' = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
        'RegPath' = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'
        'RegPathUser' = 'HKCU:\Software\Microsoft\Edge\Extensions'
        'ExtKey' = 'nfvdid_cookie_injector'
    }
}

$config = $browserPaths[$Browser]

function Write-Banner {
    Write-Host "`n" -ForegroundColor Green
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║         LaorORG © Netfix Extension Auto-Installer            ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "→ $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

Write-Banner

Write-Step "Installing for $Browser"

# Check if browser is installed
if (-not (Test-Path $config.Exe)) {
    Write-Error-Custom "$Browser is not installed at: $($config.Exe)"
    exit 1
}
Write-Success "$Browser found"

# Create temp directory
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
Write-Success "Temp directory created"

# Download extension
Write-Step "Downloading extension from GitHub..."
try {
    Invoke-WebRequest -Uri $ExtensionUrl -OutFile $zipPath -TimeoutSec 30
    Write-Success "Downloaded $(Get-Item $zipPath).Length bytes)"
} catch {
    Write-Error-Custom "Failed to download extension: $_"
    exit 1
}

# Extract extension
Write-Step "Extracting extension..."
if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
New-Item -ItemType Directory -Path $extractPath -Force | Out-Null

try {
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
    $extracted = Get-ChildItem $tempDir -Exclude extension.zip | Select-Object -First 1
    if ($extracted) {
        Copy-Item "$($extracted.FullName)\*" -Destination $extractPath -Recurse -Force
    } else {
        Copy-Item "$tempDir\*" -Destination $extractPath -Recurse -Force -Exclude extension.zip
    }
    Write-Success "Extracted to $extractPath"
} catch {
    Write-Error-Custom "Failed to extract: $_"
    exit 1
}

# Verify manifest
if (-not (Test-Path "$extractPath\manifest.json")) {
    Write-Error-Custom "manifest.json not found in extracted extension"
    exit 1
}
Write-Success "Manifest verified"

# Registry configuration for forced load (Enterprise policy)
Write-Step "Configuring registry for auto-load..."
try {
    # Ensure registry paths exist
    if (-not (Test-Path $config.RegPathUser)) {
        New-Item -Path $config.RegPathUser -Force | Out-Null
    }
    
    # Create extension entry
    $extKeyPath = "$($config.RegPathUser)\$($config.ExtKey)"
    New-Item -Path $extKeyPath -Force | Out-Null
    Set-ItemProperty -Path $extKeyPath -Name "path" -Value $extractPath
    Set-ItemProperty -Path $extKeyPath -Name "version" -Value "1.0.0"
    
    Write-Success "Registry configured"
} catch {
    Write-Host "⚠ Registry config skipped (may require different approach)" -ForegroundColor Yellow
}

# Launch browser with extension loaded
Write-Step "Launching $Browser..."
try {
    Start-Process $config.Exe -ArgumentList "--load-extension=$extractPath", "https://www.netflix.com" -NoNewWindow
    Write-Success "$Browser launched with extension"
} catch {
    Write-Host "⚠ Could not auto-launch $Browser. Please open it manually." -ForegroundColor Yellow
}

# Wait for browser to start
Start-Sleep -Seconds 2

# Manual override: Create shortcut for one-click re-load
$shortcutPath = "$env:USERPROFILE\Desktop\LaorORG-Netfix.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortCut($shortcutPath)
$shortcut.TargetPath = $config.Exe
$shortcut.Arguments = "--load-extension=$extractPath"
$shortcut.Description = "Launch $Browser with LaorORG © Netfix Extension"
$shortcut.Save()
Write-Success "Desktop shortcut created: LaorORG-Netfix.lnk"

# Cleanup
Remove-Item $tempDir -Recurse -Force
Write-Success "Temp files cleaned up"

Write-Host "`n" -ForegroundColor Green
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    Installation Complete!                    ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "Extension location: $extractPath" -ForegroundColor Cyan
Write-Host "Desktop shortcut: $shortcutPath" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. $Browser is launching with the extension loaded"
Write-Host "2. Go to $Browser://extensions/ to verify the extension is loaded"
Write-Host "3. Click the LaorORG © Netfix icon to inject your Netflix cookie"
Write-Host "4. Use the desktop shortcut to launch $Browser with the extension anytime"
Write-Host ""

Write-Host "To modify the cookie:" -ForegroundColor Yellow
Write-Host "1. Edit: $extractPath\popup.js"
Write-Host "2. Find: const SAVED_COOKIES = ["
Write-Host "3. Update the 'value' field with your Netflix nfvdid cookie"
Write-Host "4. Reload the extension in $Browser://extensions/"
Write-Host ""
