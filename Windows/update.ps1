# update.ps1
$ErrorActionPreference = "Stop"

$GITHUB_USER = "JOUW_GITHUB_NAAM"
$GITHUB_REPO = "AutoBuilder-Pro"
$BRANCH = "main"
$BASE_URL = "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

$INSTALL_DIR = "$HOME\.autobuilder"
$FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO UPDATER (WINDOWS) ===" -ForegroundColor Cyan

foreach ($file in $FILES) {
    Write-Host "❯ Updaten: $file..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

Write-Host "✔ Alle bestanden zijn weer up-to-date!" -ForegroundColor Green
