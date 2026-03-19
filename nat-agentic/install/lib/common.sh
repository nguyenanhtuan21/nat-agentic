#!/usr/bin/env bash
#
# Common functions for Nat Agentic installer
#

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Print functions
nat_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
nat_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
nat_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
nat_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Check if command exists
nat_command_exists() {
    command -v "$1" &> /dev/null
}

# Get latest version from GitHub
nat_get_latest_version() {
    local repo="${1:-nat-agentic/nat-agentic}"
    local version

    version=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')

    if [[ -z "$version" ]]; then
        version="1.0.0"
    fi

    echo "$version"
}

# Compare versions
nat_compare_versions() {
    local v1="$1"
    local v2="$2"

    if [[ "$v1" == "$v2" ]]; then
        echo "equal"
        return
    fi

    local IFS=.
    local i ver1=($v1) ver2=($v2)

    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi

        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            echo "greater"
            return
        fi

        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            echo "less"
            return
        fi
    done

    echo "equal"
}

# Download file
nat_download() {
    local url="$1"
    local output="$2"

    if nat_command_exists curl; then
        curl -fsSL "$url" -o "$output"
    elif nat_command_exists wget; then
        wget -q "$url" -O "$output"
    else
        nat_error "curl or wget required"
        return 1
    fi
}

# Extract archive
nat_extract() {
    local archive="$1"
    local dest="$2"

    mkdir -p "$dest"

    case "$archive" in
        *.tar.gz|*.tgz)
            tar -xzf "$archive" -C "$dest" --strip-components=1
            ;;
        *.zip)
            if nat_command_exists unzip; then
                unzip -q "$archive" -d "$dest"
            else
                nat_error "unzip required"
                return 1
            fi
            ;;
        *)
            nat_error "Unsupported archive format: $archive"
            return 1
            ;;
    esac
}

# Create backup
nat_backup() {
    local path="$1"
    local backup="${path}.backup.$(date +%Y%m%d_%H%M%S)"

    if [[ -e "$path" ]]; then
        cp -r "$path" "$backup"
        echo "$backup"
    fi
}

# Cleanup
nat_cleanup() {
    local tmp_dir="$1"
    if [[ -d "$tmp_dir" ]]; then
        rm -rf "$tmp_dir"
    fi
}
