#!/bin/bash

set -e

echo "Installing personal development environment..."

sudo apt update && sudo apt upgrade -y

# ─────────────────────────────────────────────
# Rust
# ─────────────────────────────────────────────

if ! command -v rustup >/dev/null 2>&1; then
    echo "Installing Rust..."

    curl --proto '=https' \
         --tlsv1.2 \
         -sSf https://sh.rustup.rs | sh -s -- -y
fi

source "$HOME/.cargo/env" 2>/dev/null || true

# ─────────────────────────────────────────────
# Starship
# ─────────────────────────────────────────────

if ! command -v starship >/dev/null 2>&1; then
    echo "Installing Starship..."

    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ─────────────────────────────────────────────
# Nerd Fonts
# ─────────────────────────────────────────────

FONT_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONT_DIR"

cd "$FONT_DIR"

if [ ! -f "JetBrainsMonoNerdFontMono-Regular.ttf" ]; then
    echo "Installing JetBrains Mono Nerd Font..."

    curl -L \
        -o JetBrainsMono.tar.xz \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

    tar -xf JetBrainsMono.tar.xz
    rm JetBrainsMono.tar.xz
fi

if [ ! -f "CousineNerdFontMono-Regular.ttf" ]; then
    echo "Installing Cousine Nerd Font..."

    curl -L \
        -o Cousine.tar.xz \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Cousine.tar.xz

    tar -xf Cousine.tar.xz
    rm Cousine.tar.xz
fi

fc-cache -fv >/dev/null 2>&1 || true

# ─────────────────────────────────────────────
# Starship configuration
# ─────────────────────────────────────────────

mkdir -p "$HOME/.config"

cp "$(dirname "$0")/.config/starship.toml" \
   "$HOME/.config/starship.toml"

# ─────────────────────────────────────────────
# Bash configuration
# ─────────────────────────────────────────────

if ! grep -q 'starship init bash' "$HOME/.bashrc" 2>/dev/null; then
    echo '' >> "$HOME/.bashrc"
    echo '# Starship' >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi

echo ""
echo "✓ Development environment installed!"
echo ""
echo "Rust:"
rustc --version 2>/dev/null || true

echo "Starship:"
starship --version 2>/dev/null || true


sudo apt-get install -y fzf

# Install ble.sh
if [ ! -d "$HOME/.local/share/blesh" ]; then
    mkdir -p "$HOME/.local/share"
    git clone --recursive \
        https://github.com/akinomyoga/ble.sh.git \
        "$HOME/.local/share/blesh"
fi

# Install Atuin
if ! command -v atuin >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -LsSf \
        https://setup.atuin.sh | sh
fi
