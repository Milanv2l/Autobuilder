#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/Milanv2l/Autobuilder/main"
INSTALL_DIR="$HOME/.autobuilder"
PYTHON_FILES=("autobuilder.py" "core.py" "engine.py" "plugins.json")

echo -e "\033[96m=== AUTOBUILDER PRO UPDATER (LINUX) ===\033[0m"

for file in "${PYTHON_FILES[@]}"; do
    echo -e "\033[94m❯ Updaten:\033[0m $file..."
    curl -fsSL "$BASE_URL/$file" -o "$INSTALL_DIR/$file"
done

echo -e "\033[94m❯ Updaten:\033[0m update.sh..."
curl -fsSL "$BASE_URL/Linux/update.sh" -o "$INSTALL_DIR/update.sh"
chmod +x "$INSTALL_DIR/update.sh"

echo -e "\033[92m✔ Alle bestanden zijn weer up-to-date!\033[0m"
