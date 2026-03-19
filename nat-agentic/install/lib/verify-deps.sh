#!/usr/bin/env bash
#
# Dependency verification for Nat Agentic installer
#

# Verify all dependencies
nat_verify_dependencies() {
    local missing=()
    local os=$(nat_detect_os)

    # Check git
    if ! nat_command_exists git; then
        missing+=("git")
    fi

    # Check curl or wget
    if ! nat_command_exists curl && ! nat_command_exists wget; then
        missing+=("curl or wget")
    fi

    # Check Node.js or Bun
    if ! nat_command_exists node && ! nat_command_exists bun; then
        missing+=("nodejs or bun")
    fi

    # Check npm if node is present
    if nat_command_exists node && ! nat_command_exists npm; then
        missing+=("npm")
    fi

    # Return results
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "missing:${missing[*]}"
        return 1
    else
        echo "ok"
        return 0
    fi
}

# Install missing dependencies
nat_install_dependencies() {
    local os=$(nat_detect_os)
    local pm=$(nat_get_package_manager)

    nat_info "Installing missing dependencies..."

    case "$pm" in
        brew)
            # Check if brew is installed
            if ! nat_command_exists brew; then
                nat_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            # Install packages
            nat_command_exists git || brew install git
            nat_command_exists curl || brew install curl
            nat_command_exists node || brew install node
            ;;

        apt)
            sudo apt-get update
            nat_command_exists git || sudo apt-get install -y git
            nat_command_exists curl || sudo apt-get install -y curl
            nat_command_exists node || {
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt-get install -y nodejs
            }
            ;;

        dnf)
            nat_command_exists git || sudo dnf install -y git
            nat_command_exists curl || sudo dnf install -y curl
            nat_command_exists node || sudo dnf install -y nodejs
            ;;

        yum)
            nat_command_exists git || sudo yum install -y git
            nat_command_exists curl || sudo yum install -y curl
            nat_command_exists node || {
                curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
                sudo yum install -y nodejs
            }
            ;;

        pacman)
            nat_command_exists git || sudo pacman -S --noconfirm git
            nat_command_exists curl || sudo pacman -S --noconfirm curl
            nat_command_exists node || sudo pacman -S --noconfirm nodejs npm
            ;;

        apk)
            nat_command_exists git || sudo apk add git
            nat_command_exists curl || sudo apk add curl
            nat_command_exists node || sudo apk add nodejs npm
            ;;

        *)
            nat_error "Unknown package manager. Please install dependencies manually:"
            echo "  - git"
            echo "  - curl or wget"
            echo "  - Node.js (v18+) or Bun"
            return 1
            ;;
    esac

    nat_success "Dependencies installed"
}

# Verify Claude Code installation
nat_verify_claude_code() {
    if nat_command_exists claude; then
        local version=$(claude --version 2>/dev/null || echo "unknown")
        nat_success "Claude Code installed: $version"
        return 0
    else
        return 1
    fi
}

# Install Claude Code
nat_install_claude_code() {
    nat_info "Installing Claude Code..."

    if nat_command_exists npm; then
        npm install -g @anthropic-ai/claude-code
    elif nat_command_exists bun; then
        bun install -g @anthropic-ai/claude-code
    else
        nat_error "npm or bun required to install Claude Code"
        return 1
    fi

    nat_verify_claude_code
}

# Full dependency check and install
nat_ensure_dependencies() {
    local result=$(nat_verify_dependencies)

    if [[ "$result" == "ok" ]]; then
        nat_success "All dependencies satisfied"
    else
        nat_warn "Missing dependencies detected"
        nat_install_dependencies
    fi

    # Ensure Claude Code
    if ! nat_verify_claude_code; then
        nat_install_claude_code
    fi
}
