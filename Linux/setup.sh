#!/bin/bash
set -e

GITHUB_USER="Milanv2l"
GITHUB_REPO="Autobuilder"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

INSTALL_DIR="$HOME/.autobuilder"
PYTHON_FILES=("autobuilder.py" "core.py" "engine.py" "baremetal.py" "plugins.json")

echo -e "\033[96m=== AUTOBUILDER PRO INSTALLATIE ===\033[0m"

# --- VRAAG 1: Installeren? ---
read -p "Wil je AutoBuilder Pro op dit systeem installeren? (j/n): " confirm_install < /dev/tty
if [[ ! "$confirm_install" =~ ^[jJ](a|A)?$ ]]; then
    echo -e "\033[93mInstallatie geannuleerd door gebruiker.\033[0m"
    exit 0
fi

# --- VRAAG 2: Docker Sandbox? ---
read -p "Wil je gebruik maken van de veilige Docker container sandbox? (Aanbevolen) (j/n): " use_docker < /dev/tty
if [[ "$use_docker" =~ ^[jJ](a|A)?$ ]]; then
    if ! command -v docker &> /dev/null; then
        echo -e "\033[93m⚡ Docker niet gevonden. Installatie starten...\033[0m"
        if [ -x "$(command -v dnf)" ]; then sudo dnf install -y docker
        elif [ -x "$(command -v apt-get)" ]; then sudo apt-get update && sudo apt-get install -y docker.io
        elif [ -x "$(command -v pacman)" ]; then sudo pacman -S --noconfirm docker
        else echo -e "\033[91m✖ Kon pakketbeheerder niet bepalen. Installeer Docker handmatig.\033[0m"; exit 1; fi
    else 
        echo -e "\033[92m✔ Docker is al geïnstalleerd.\033[0m"
    fi

    # Docker service starten
    if command -v systemctl &> /dev/null; then sudo systemctl enable --now docker; fi
else
    echo -e "\033[93m⚡ Docker installatie overgeslagen. AutoBuilder zal alleen via Bare-Metal werken.\033[0m"
fi

# --- DOWNLOADS & INSTALLATIE ---
echo -e "\n\033[94m❯ Bestanden downloaden naar $INSTALL_DIR...\033[0m"
mkdir -p "$INSTALL_DIR"

for file in "${PYTHON_FILES[@]}"; do
    echo "  Downloaden: $file..."
    curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/$file"
done

echo "  Downloaden: update.sh..."
curl -fsSL "$BASE_URL/Linux/update.sh" -o "$INSTALL_DIR/update.sh"
chmod +x "$INSTALL_DIR/update.sh"

# Alias aanmaken
if ! grep -q "alias autobuilder=" "$HOME/.bashrc"; then
    echo "alias autobuilder='python3 $INSTALL_DIR/autobuilder.py'" >> "$HOME/.bashrc"
    echo -e "\033[92m✔ Commando 'autobuilder' toegevoegd aan ~/.bashrc\033[0m"
fi

# --- AFRONDING ---
echo -e "\n\033[92m✔ Installatie Voltooid!\033[0m"
echo -e "\033[93m1. Typ \033[1mbash\033[0m\033[93m en druk op Enter om je terminal te verversen.\033[0m"
echo -e "\033[93m2. Typ daarna \033[1mautobuilder\033[0m\033[93m om de applicatie te starten!\033[0m\n"
