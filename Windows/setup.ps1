$ErrorActionPreference = "Stop"

$BASE_URL = "https://raw.githubusercontent.com/Milanv2l/Autobuilder/main"
$INSTALL_DIR = "$HOME\.autobuilder"
$PYTHON_FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO INSTALLATIE (WINDOWS) ===" -ForegroundColor Cyan

# --- VRAAG 1: Installeren? ---
$confirm = Read-Host "Wil je AutoBuilder Pro op dit systeem installeren? (j/n)"
if ($confirm -notmatch "^[jJ](a|A)?$") {
    Write-Host "Installatie geannuleerd door gebruiker." -ForegroundColor Yellow
    exit
}

# --- VRAAG 2: Docker Sandbox? ---
$useDocker = Read-Host "Wil je gebruik maken van de veilige Docker container sandbox? (Aanbevolen) (j/n)"
if ($useDocker -match "^[jJ](a|A)?$") {
    if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Host "⚡ Docker is niet geïnstalleerd. Installeren via Winget..." -ForegroundColor Yellow
        winget install Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "✔ Docker is al geïnstalleerd." -ForegroundColor Green
    }
} else {
    Write-Host "⚡ Docker installatie overgeslagen. AutoBuilder zal alleen via Bare-Metal werken." -ForegroundColor Yellow
}

# Python Check (Altijd nodig voor de host-menu's)
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "⚡ Python is niet geïnstalleerd! Installeren via Winget..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --silent --accept-package-agreements
}

# --- DOWNLOADS & INSTALLATIE ---
Write-Host "`n❯ Bestanden downloaden naar $INSTALL_DIR..." -ForegroundColor Cyan
if (!(Test-Path $INSTALL_DIR)) { New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null }

foreach ($file in $PYTHON_FILES) {
    Write-Host "  Downloaden: $file..."
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

Write-Host "  Downloaden: update.ps1..."
Invoke-WebRequest -Uri "$BASE_URL/Windows/update.ps1" -OutFile "$INSTALL_DIR\update.ps1" -UseBasicParsing

# Maak een .cmd wrapper
$CMD_FILE = "$INSTALL_DIR\autobuilder.cmd"
"@echo off`npython `"%~dp0autobuilder.py`" %*" | Out-File -FilePath $CMD_FILE -Encoding ascii

# Voeg toe aan PATH
$USER_PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($USER_PATH -notmatch [regex]::Escape($INSTALL_DIR)) {
    [Environment]::SetEnvironmentVariable("PATH", "$USER_PATH;$INSTALL_DIR", "User")
    Write-Host "✔ '$INSTALL_DIR' toegevoegd aan PATH." -ForegroundColor Green
}

Write-Host "`n✔ Installatie Voltooid! AutoBuilder wordt nu gestart..." -ForegroundColor Green
Start-Sleep -Seconds 1

# --- START AUTOBUILDER ---
# Zorg dat de huidige terminal de nieuwe PATH direct herkent voor deze sessie
$env:PATH = "$env:PATH;$INSTALL_DIR"
autobuilder
