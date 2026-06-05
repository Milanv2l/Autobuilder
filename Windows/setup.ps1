$ErrorActionPreference = "Stop"

$BASE_URL = "https://raw.githubusercontent.com/Milanv2l/Autobuilder/main"
$INSTALL_DIR = "$HOME\.autobuilder"
$PYTHON_FILES = @("autobuilder.py", "core.py", "engine.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO UPDATER (WINDOWS) ===" -ForegroundColor Cyan

foreach ($file in $PYTHON_FILES) {
    Write-Host "❯ Updaten: $file..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

Write-Host "❯ Updaten: update.ps1..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/Windows/update.ps1" -OutFile "$INSTALL_DIR\update.ps1" -UseBasicParsing

Write-Host "✔ Alle bestanden zijn weer up-to-date!" -ForegroundColor Green
