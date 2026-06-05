# setup.ps1
$ErrorActionPreference = "Stop"

$GITHUB_USER = "JOUW_GITHUB_NAAM"
$GITHUB_REPO = "AutoBuilder-Pro"
$BRANCH = "main"
$BASE_URL = "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

$INSTALL_DIR = "$HOME\.autobuilder"
$FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json", "update.ps1")

Write-Host "=== AUTOBUILDER PRO INSTALLATIE (WINDOWS) ===" -ForegroundColor Cyan

# 1. Docker Check (Docker Desktop)
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "⚡ Docker is niet geïnstalleerd." -ForegroundColor Yellow
    Write-Host "Probeer Docker Desktop te installeren via Winget..." -ForegroundColor Cyan
    winget install Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
    Write-Host "Let op: Je moet waarschijnlijk je PC opnieuw opstarten nadat Docker Desktop is geïnstalleerd." -ForegroundColor Yellow
} else {
    Write-Host "✔ Docker is al geïnstalleerd." -ForegroundColor Green
}

# 2. Python Check
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "⚡ Python is niet geïnstalleerd! AutoBuilder heeft Python nodig op de host." -ForegroundColor Red
    Write-Host "Installeren via Winget..." -ForegroundColor Cyan
    winget install Python.Python.3.12 --silent --accept-package-agreements
}

# 3. Mappen aanmaken
Write-Host "`n❯ Bestanden downloaden naar $INSTALL_DIR..." -ForegroundColor Cyan
if (!(Test-Path $INSTALL_DIR)) { New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null }

# 4. Bestanden downloaden
foreach ($file in $FILES) {
    Write-Host "  Downloaden: $file..."
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

# 5. Maak een .cmd wrapper zodat 'autobuilder' als commando werkt in CMD & PowerShell
$CMD_FILE = "$INSTALL_DIR\autobuilder.cmd"
"@echo off`npython `"%~dp0autobuilder.py`" %*" | Out-File -FilePath $CMD_FILE -Encoding ascii

# 6. Voeg de map toe aan de Windows PATH (User level)
$USER_PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($USER_PATH -notmatch [regex]::Escape($INSTALL_DIR)) {
    Write-Host "❯ Map toevoegen aan Windows PATH..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("PATH", "$USER_PATH;$INSTALL_DIR", "User")
    Write-Host "✔ '$INSTALL_DIR' toegevoegd aan PATH." -ForegroundColor Green
}

Write-Host "`n✔ Installatie Voltooid!" -ForegroundColor Green
Write-Host "Sluit deze terminal en open een nieuwe om het commando 'autobuilder' te kunnen gebruiken." -ForegroundColor Yellow
