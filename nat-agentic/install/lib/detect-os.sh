#!/usr/bin/env bash
#
# OS detection functions for Nat Agentic installer
#

# Detect operating system
nat_detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        CYGWIN*)    echo "windows" ;;
        MINGW*)     echo "windows" ;;
        MSYS*)      echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# Detect Linux distribution
nat_detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif [[ -f /etc/lsb-release ]]; then
        . /etc/lsb-release
        echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Detect architecture
nat_detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)   echo "x64" ;;
        arm64|aarch64)  echo "arm64" ;;
        armv7l)         echo "arm" ;;
        i386|i686)      echo "x86" ;;
        *)              echo "unknown" ;;
    esac
}

# Get package manager
nat_get_package_manager() {
    local os=$(nat_detect_os)

    case "$os" in
        macos)
            if nat_command_exists brew; then
                echo "brew"
            else
                echo "none"
            fi
            ;;
        linux)
            local distro=$(nat_detect_distro)
            case "$distro" in
                ubuntu|debian|linuxmint|pop)
                    echo "apt"
                    ;;
                fedora)
                    echo "dnf"
                    ;;
                centos|rhel|rocky|almalinux)
                    echo "yum"
                    ;;
                arch|manjaro)
                    echo "pacman"
                    ;;
                opensuse*)
                    echo "zypper"
                    ;;
                alpine)
                    echo "apk"
                    ;;
                *)
                    echo "none"
                    ;;
            esac
            ;;
        windows)
            if nat_command_exists winget; then
                echo "winget"
            elif nat_command_exists scoop; then
                echo "scoop"
            elif nat_command_exists choco; then
                echo "choco"
            else
                echo "none"
            fi
            ;;
        *)
            echo "none"
            ;;
    esac
}

# Check if running as root
nat_is_root() {
    [[ $EUID -eq 0 ]]
}

# Get user home directory
nat_get_home() {
    if [[ -n "$SUDO_USER" ]]; then
        eval echo "~$SUDO_USER"
    else
        echo "$HOME"
    fi
}

# Get shell configuration file
nat_get_shell_rc() {
    local shell_name=$(basename "${SHELL:-bash}")

    case "$shell_name" in
        bash)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}
