#!/bin/bash
set -e

# Vervang dit door jouw daadwerkelijke GitHub gegevens
GITHUB_USER="JOUW_GITHUB_NAAM"
GITHUB_REPO="AutoBuilder-Pro"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

INSTALL_DIR="$HOME/.autobuilder"
FILES=("autobuilder.py" "core.py" "engine.py" "baremetal.py" "plugins.json" "update.sh")

echo -e "\033[96m=== AUTOBUILDER PRO INSTALLATIE ===\033[0m"

# 1. Docker installatie check
if ! command -v docker &> /dev/null; then
    echo -e "\033[93m⚡ Docker niet gevonden. Installatie starten...\033[0m"

    if [ -x "$(command -v dnf)" ]; then
        echo "Fedora/RHEL gedetecteerd. Docker installeren via DNF..."
        sudo dnf install -y docker
    elif [ -x "$(command -v apt-get)" ]; then
        echo "Debian/Ubuntu gedetecteerd. Docker installeren via APT..."
        sudo apt-get update
        sudo apt-get install -y docker.io
    elif [ -x "$(command -v pacman)" ]; then
        echo "Arch Linux gedetecteerd. Docker installeren via Pacman..."
        sudo pacman -S --noconfirm docker
    else
        echo -e "\033[91m✖ Kon pakketbeheerder niet bepalen. Installeer Docker handmatig.\033[0m"
        exit 1
    fi
else
    echo -e "\033[92m✔ Docker is al geïnstalleerd.\033[0m"
fi

# 2. Docker service starten & enablen (Zodat het ook na reboot werkt, vooral belangrijk op Fedora)
if command -v systemctl &> /dev/null; then
    echo "Docker service inschakelen..."
    sudo systemctl enable --now docker
fi

# 3. Mappen aanmaken
echo -e "\n\033[94m❯ Bestanden downloaden naar $INSTALL_DIR...\033[0m"
mkdir -p "$INSTALL_DIR"

# 4. Bestanden downloaden van GitHub
for file in "${FILES[@]}"; do
    echo "  Downloaden: $file..."
    curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/$file"
done

# 5. Maak de updater uitvoerbaar
chmod +x "$INSTALL_DIR/update.sh"

# 6. Alias aanmaken zodat het overal werkt
if ! grep -q "alias autobuilder" "$HOME/.bashrc"; then
    echo "alias autobuilder='python3 $INSTALL_DIR/autobuilder.py'" >> "$HOME/.bashrc"
    echo -e "\033[92m✔ Commando 'autobuilder' toegevoegd aan ~/.bashrc\033[0m"
fi

echo -e "\n\033[92m✔ Installatie Voltooid!\033[0m"
echo -e "\033[93mLet op: Herstart je terminal of typ 'source ~/.bashrc' om het 'autobuilder' commando te kunnen gebruiken.\033[0m"
