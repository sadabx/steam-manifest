#!/bin/bash
set -e

echo "=> Fetching latest release of TOST..."
LATEST_RELEASE=$(curl -s https://api.github.com/repos/sadabx/TOST/releases/latest)
VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name": "\K(.*)(?=")')

if [ -z "$VERSION" ]; then
    echo "Error: Could not determine latest version."
    exit 1
fi
echo "=> Found version $VERSION"

RAW_VERSION=${VERSION#v}
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if command -v pacman >/dev/null 2>&1; then
    # Arch Linux
    FILE="tost-${RAW_VERSION}-1-x86_64.pkg.tar.zst"
    URL="https://github.com/sadabx/TOST/releases/download/${VERSION}/${FILE}"
    echo "=> Downloading Arch package ($FILE)..."
    curl -sSL "$URL" -o "$FILE"
    echo "=> Installing via pacman (requires sudo)..."
    sudo pacman -U --noconfirm "$FILE"
elif command -v apt >/dev/null 2>&1; then
    # Debian/Ubuntu
    FILE="tost_${RAW_VERSION}_amd64.deb"
    URL="https://github.com/sadabx/TOST/releases/download/${VERSION}/${FILE}"
    echo "=> Downloading Debian package ($FILE)..."
    curl -sSL "$URL" -o "$FILE"
    echo "=> Installing via apt (requires sudo)..."
    sudo apt install -y "./$FILE"
else
    # Fallback to AppImage
    FILE="TOST-${RAW_VERSION}-x86_64.AppImage"
    URL="https://github.com/sadabx/TOST/releases/download/${VERSION}/${FILE}"
    echo "=> Downloading AppImage ($FILE)..."
    curl -sSL "$URL" -o "$FILE"
    chmod +x "$FILE"
    mkdir -p ~/.local/bin
    mv "$FILE" ~/.local/bin/TOST
    echo "=> Installed to ~/.local/bin/TOST"
    echo "=> Please ensure ~/.local/bin is in your PATH."
fi

cd - >/dev/null
rm -rf "$TMP_DIR"
echo "=> TOST installation complete!"
