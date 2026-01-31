#!/bin/bash

# COLORS
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

INSTALL_DIR="$HOME/.auto-commit"
SCRIPT_URL="https://raw.githubusercontent.com/synapsyz/auto-commit/main/commit.py"
# NOTE: If you are testing locally, the script copies from local dir. 
# If running via curl, it downloads.

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   🚀 auto-commit Installer Setup      ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 1. CHECK PYTHON
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed. Please install it first.${NC}"
    exit 1
fi

# 2. CREATE DIRECTORY
if [ -d "$INSTALL_DIR" ]; then
    echo -e "📂 Updating existing installation..."
else
    echo -e "📂 Creating install directory at $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# 3. INSTALL DEPENDENCIES
echo -e "⬇️  Installing Python dependencies..."
pip3 install requests > /dev/null 2>&1

# 4. SETUP API KEY
CONFIG_FILE="$INSTALL_DIR/config.json"
echo -e ""
if [ -f "$CONFIG_FILE" ]; then
    echo -e "✅ API Key already configured."
    read -p "Do you want to re-enter your Groq API Key? (y/N): " RE_ENTER
    if [[ "$RE_ENTER" =~ ^[Yy]$ ]]; then
        CONFIGURE_KEY=true
    else
        CONFIGURE_KEY=false
    fi
else
    CONFIGURE_KEY=true
fi

if [ "$CONFIGURE_KEY" = true ]; then
    echo -e "${BLUE}🔑 Groq API Setup${NC}"
    echo "You need a free Groq API Key to use this tool."
    echo "If you don't have one, get it here: https://console.groq.com/keys"
    echo ""
    read -p "Paste your Groq API Key here: " API_KEY

    while [[ -z "$API_KEY" ]]; do
        echo -e "${RED}❌ Key cannot be empty.${NC}"
        read -p "Paste your Groq API Key here: " API_KEY
    done

    # Save to JSON
    echo "{\"GROQ_API_KEY\": \"$API_KEY\"}" > "$CONFIG_FILE"
    echo -e "✅ Key saved securely."
fi

# 5. COPY SCRIPT
# If running from within the repo (local install)
if [ -f "commit.py" ]; then
    cp commit.py "$INSTALL_DIR/commit.py"
else
    # If running via curl (remote install), download it
    echo -e "⬇️  Downloading latest script..."
    curl -s -o "$INSTALL_DIR/commit.py" "$SCRIPT_URL"
fi

# 6. SETUP ALIAS
SHELL_CONFIG="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

ALIAS_CMD="alias commit='python3 $INSTALL_DIR/commit.py'"

if grep -Fxq "$ALIAS_CMD" "$SHELL_CONFIG"; then
    echo -e "✅ Alias 'commit' already exists."
else
    echo "" >> "$SHELL_CONFIG"
    echo "# auto-commit tool" >> "$SHELL_CONFIG"
    echo "$ALIAS_CMD" >> "$SHELL_CONFIG"
    echo -e "✅ Alias 'commit' added to $SHELL_CONFIG"
fi

echo -e ""
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo -e "👉 Restart your terminal or run: ${BLUE}source $SHELL_CONFIG${NC}"
echo -e "👉 Then just type: ${BLUE}commit${NC} inside any git repo."