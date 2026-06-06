$ErrorActionPreference = "Stop"

$GITHUB_USER = "Milanv2l"
$GITHUB_REPO = "Autobuilder"
$BRANCH = "main"
$BASE_URL = "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

$INSTALL_DIR = "$HOME\.autobuilder"
$PYTHON_FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO UPDATE ===" -ForegroundColor Cyan
Write-Host "Bestanden downloaden..." -ForegroundColor Cyan

foreach ($file in $PYTHON_FILES) {
    Write-Host "  Downloaden: $file..."
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

Write-Host "[OK] Alle bestanden zijn weer up-to-date!" -ForegroundColor Green$ErrorActionPreference = "Stop"

# Locatie van jouw repository
$BASE_URL = "https://raw.githubusercontent.com/Milanv2l/Autobuilder/main"
# Lokale installatiemap
$INSTALL_DIR = "$HOME\.autobuilder"
# Alle bestanden die geüpdatet moeten worden
$FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO UPDATER (WINDOWS) ===" -ForegroundColor Cyan

# Download de python scripts
foreach ($file in $FILES) {
    Write-Host "❯ Updaten: $file..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

# Download het update script zelf opnieuw voor eventuele wijzigingen
Write-Host "❯ Updaten: update.ps1..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/Windows/update.ps1" -OutFile "$INSTALL_DIR\update.ps1" -UseBasicParsing

Write-Host "✔ Alle bestanden zijn weer up-to-date!" -ForegroundColor Green
