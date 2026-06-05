#!/bin/bash
set -e

GITHUB_USER="JOUW_GITHUB_NAAM"
GITHUB_REPO="AutoBuilder-Pro"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

INSTALL_DIR="$HOME/.autobuilder"
FILES=("autobuilder.py" "core.py" "engine.py" "baremetal.py" "plugins.json")

echo -e "\033[96m=== AUTOBUILDER PRO UPDATER ===\033[0m"

for file in "${FILES[@]}"; do
    echo -e "\033[94m❯ Updaten:\033[0m $file..."
    curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/$file"
done

echo -e "\033[92m✔ Alle bestanden zijn weer up-to-date!\033[0m"
