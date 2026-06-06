$ErrorActionPreference = "Stop"

$GITHUB_USER = "Milanv2l"
$GITHUB_REPO = "Autobuilder"
$BRANCH = "main"
$BASE_URL = "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

$INSTALL_DIR = "$HOME\.autobuilder"
$PYTHON_FILES = @("autobuilder.py", "core.py", "engine.py", "baremetal.py", "plugins.json")

Write-Host "=== AUTOBUILDER PRO INSTALLATIE (WINDOWS) ===" -ForegroundColor Cyan

# --- VRAAG 1: Installeren? ---
$confirm_install = Read-Host "Wil je AutoBuilder Pro op dit systeem installeren? (j/n)"
if ($confirm_install -notmatch "^[jJ](a|A)?$") {
    Write-Host "Installatie geannuleerd door gebruiker." -ForegroundColor Yellow
    exit
}

# --- VRAAG 2: Docker Sandbox? ---
$use_docker = Read-Host "Wil je gebruik maken van de veilige Docker container sandbox? (Aanbevolen) (j/n)"
if ($use_docker -match "^[jJ](a|A)?$") {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        Write-Host "[OK] Docker is al geinstalleerd." -ForegroundColor Green
    } else {
        Write-Host "[!] Docker niet gevonden." -ForegroundColor Yellow
        Write-Host "Ga naar https://docs.docker.com/desktop/windows/ om Docker Desktop te installeren." -ForegroundColor Yellow
    }
} else {
    Write-Host "[!] Docker installatie overgeslagen. AutoBuilder zal alleen via Bare-Metal werken." -ForegroundColor Yellow
}

# --- DOWNLOADS & INSTALLATIE ---
Write-Host "`nBestanden downloaden naar $INSTALL_DIR..." -ForegroundColor Cyan
if (-not (Test-Path -Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null
}

foreach ($file in $PYTHON_FILES) {
    Write-Host "  Downloaden: $file..."
    Invoke-WebRequest -Uri "$BASE_URL/$file" -OutFile "$INSTALL_DIR\$file" -UseBasicParsing
}

Write-Host "  Downloaden: update.ps1..."
Invoke-WebRequest -Uri "$BASE_URL/Windows/update.ps1" -OutFile "$INSTALL_DIR\update.ps1" -UseBasicParsing

# Alias aanmaken in het PowerShell Profile
$PROFILE_DIR = Split-Path -Parent $PROFILE
if (-not (Test-Path -Path $PROFILE_DIR)) {
    New-Item -ItemType Directory -Path $PROFILE_DIR | Out-Null
}
if (-not (Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE | Out-Null
}

$ALIAS_LINE = "Set-Alias -Name autobuilder -Value python -Option AllScope; function autobuilder { python `"$INSTALL_DIR\autobuilder.py`" }"
$PROFILE_CONTENT = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

if ($PROFILE_CONTENT -notmatch "function autobuilder") {
    Add-Content -Path $PROFILE -Value "`n$ALIAS_LINE"
    Write-Host "[OK] Commando 'autobuilder' toegevoegd aan je PowerShell profiel." -ForegroundColor Green
}

# --- AFRONDING ---
Write-Host "`n[OK] Installatie Voltooid!" -ForegroundColor Green
Write-Host "1. Sluit deze PowerShell en open een nieuwe (of typ 'pwsh' / 'powershell')." -ForegroundColor Yellow
Write-Host "2. Typ daarna 'autobuilder' om de applicatie te starten!`n" -ForegroundColor Yellow
