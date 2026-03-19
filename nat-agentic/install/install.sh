#!/usr/bin/env bash
#
# Nat Agentic Installer for macOS and Linux
# https://nat-agentic.dev
#
# Usage:
#   curl -fsSL https://nat-agentic.dev/install.sh | bash
#
# Environment variables:
#   NAT_AGENTIC_VERSION - Install specific version (default: latest)
#   NAT_AGENTIC_HOME    - Installation directory (default: ~/.nat-agentic)
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Version
NAT_AGENTIC_VERSION="${NAT_AGENTIC_VERSION:-latest}"
NAT_AGENTIC_HOME="${NAT_AGENTIC_HOME:-$HOME/.nat-agentic}"
NAT_AGENTIC_REPO="nat-agentic/nat-agentic"

# Print functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Detect architecture
detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)   echo "x64" ;;
        arm64|aarch64)  echo "arm64" ;;
        *)              echo "unknown" ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install dependencies
install_dependencies() {
    local os=$(detect_os)

    info "Checking dependencies..."

    # Check for git
    if ! command_exists git; then
        warn "Git not found. Installing..."
        case "$os" in
            macos)
                if command_exists brew; then
                    brew install git
                else
                    error "Please install Homebrew first: https://brew.sh"
                    exit 1
                fi
                ;;
            linux)
                if command_exists apt-get; then
                    sudo apt-get update && sudo apt-get install -y git
                elif command_exists dnf; then
                    sudo dnf install -y git
                elif command_exists yum; then
                    sudo yum install -y git
                else
                    error "Please install git manually"
                    exit 1
                fi
                ;;
        esac
    fi

    # Check for Node.js
    if ! command_exists node && ! command_exists bun; then
        warn "Node.js/Bun not found. Installing Bun..."
        if command_exists curl; then
            curl -fsSL https://bun.sh/install | bash
        else
            error "Please install Node.js or Bun manually"
            exit 1
        fi
    fi

    # Check for Claude Code
    if ! command_exists claude; then
        warn "Claude Code not found. Installing..."
        if command_exists npm; then
            npm install -g @anthropic-ai/claude-code
        elif command_exists bun; then
            bun install -g @anthropic-ai/claude-code
        fi
    fi

    success "All dependencies installed"
}

# Download Nat Agentic
download_nat_agentic() {
    local version="$1"
    local download_url

    info "Downloading Nat Agentic ${version}..."

    # Create temp directory
    local tmp_dir=$(mktemp -d)
    trap "rm -rf $tmp_dir" EXIT

    if [[ "$version" == "latest" ]]; then
        download_url="https://github.com/${NAT_AGENTIC_REPO}/archive/refs/heads/main.tar.gz"
    else
        download_url="https://github.com/${NAT_AGENTIC_REPO}/archive/refs/tags/v${version}.tar.gz"
    fi

    # Download and extract
    if command_exists curl; then
        curl -fsSL "$download_url" | tar -xzf - -C "$tmp_dir" --strip-components=1
    elif command_exists wget; then
        wget -qO- "$download_url" | tar -xzf - -C "$tmp_dir" --strip-components=1
    else
        error "curl or wget required"
        exit 1
    fi

    echo "$tmp_dir"
}

# Install Nat Agentic
install_nat_agentic() {
    local source_dir="$1"

    info "Installing Nat Agentic..."

    # Create directories
    mkdir -p "$NAT_AGENTIC_HOME/bin"
    mkdir -p "$NAT_AGENTIC_HOME/config"
    mkdir -p "$NAT_AGENTIC_HOME/marketplace"
    mkdir -p "$NAT_AGENTIC_HOME/branding"

    # Copy files
    cp -r "$source_dir/bin/"* "$NAT_AGENTIC_HOME/bin/"
    cp -r "$source_dir/config/"* "$NAT_AGENTIC_HOME/config/"
    cp -r "$source_dir/marketplace/"* "$NAT_AGENTIC_HOME/marketplace/"
    cp -r "$source_dir/branding/"* "$NAT_AGENTIC_HOME/branding/"
    cp "$source_dir/VERSION" "$NAT_AGENTIC_HOME/VERSION"

    # Make scripts executable
    chmod +x "$NAT_AGENTIC_HOME/bin/"*

    success "Nat Agentic installed to $NAT_AGENTIC_HOME"
}

# Add to PATH
add_to_path() {
    local shell_rc=""
    local shell_name=$(basename "$SHELL")

    case "$shell_name" in
        bash) shell_rc="$HOME/.bashrc" ;;
        zsh)  shell_rc="$HOME/.zshrc" ;;
        fish) shell_rc="$HOME/.config/fish/config.fish" ;;
        *)    warn "Unknown shell: $shell_name. Please add $NAT_AGENTIC_HOME/bin to PATH manually"; return ;;
    esac

    local path_line="export PATH=\"\$PATH:$NAT_AGENTIC_HOME/bin\""
    local home_line="export NAT_AGENTIC_HOME=\"$NAT_AGENTIC_HOME\""

    # Check if already in PATH
    if ! grep -q "NAT_AGENTIC_HOME" "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# Nat Agentic" >> "$shell_rc"
        echo "$home_line" >> "$shell_rc"
        echo "$path_line" >> "$shell_rc"
        success "Added Nat Agentic to PATH in $shell_rc"
    else
        info "Nat Agentic already in PATH"
    fi
}

# Create symlink in /usr/local/bin (optional)
create_symlink() {
    if [[ -w /usr/local/bin ]]; then
        ln -sf "$NAT_AGENTIC_HOME/bin/nat" /usr/local/bin/nat
        success "Created symlink in /usr/local/bin/nat"
    fi
}

# Main installation
main() {
    echo -e "${PURPLE}"
    echo "  _   _ _______  ______  _   _ _____    _    _ _   _ _ _   _"
    echo " | \\ | | ____\\ \\/ /  _ \\| \\ | | ____|  / \\  | | \\ | | | \\ | |"
    echo " |  \\| |  _|  \\  /| |_) |  \\| |  _|   / _ \\ | |  \\| | |  \\| |"
    echo " | |\\  | |___ /  \\|  __/| |\\  | |___ / ___ \\| | |\\  | | |\\  |"
    echo " |_| \\_|_____/_/\\_\\_|   |_| \\_|_____/_/   \\_\\_|_| \\_|_|_| \\_|"
    echo -e "${NC}"
    echo ""
    info "Starting installation..."
    echo ""

    # Check OS
    local os=$(detect_os)
    local arch=$(detect_arch)

    info "Detected: $os ($arch)"

    # Install dependencies
    install_dependencies

    # Download
    local tmp_dir=$(download_nat_agentic "$NAT_AGENTIC_VERSION")

    # Install
    install_nat_agentic "$tmp_dir"

    # Add to PATH
    add_to_path

    # Try to create symlink
    create_symlink

    # Run setup
    if [[ -f "$NAT_AGENTIC_HOME/bin/nat-setup" ]]; then
        info "Running setup..."
        "$NAT_AGENTIC_HOME/bin/nat-setup"
    fi

    echo ""
    success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    echo "  2. Run 'nat' to start Nat Agentic"
    echo "  3. Run 'nat --help' for available options"
    echo ""
    echo "Documentation: https://nat-agentic.dev/docs"
}

# Run main
main "$@"
