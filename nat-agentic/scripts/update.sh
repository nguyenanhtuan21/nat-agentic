#!/usr/bin/env bash
#
# Update script for Nat Agentic
#

set -e

NAT_AGENTIC_HOME="${NAT_AGENTIC_HOME:-$HOME/.nat-agentic}"
VERSION_FILE="$NAT_AGENTIC_HOME/VERSION"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[Nat Agentic] Checking for updates...${NC}"

# Get current version
if [[ -f "$VERSION_FILE" ]]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
else
    CURRENT_VERSION="unknown"
fi

echo -e "${BLUE}Current version: ${CURRENT_VERSION}${NC}"

# Get latest version from GitHub
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/nat-agentic/nat-agentic/releases/latest" 2>/dev/null | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/' || echo "$CURRENT_VERSION")

echo -e "${BLUE}Latest version: ${LATEST_VERSION}${NC}"

# Compare versions
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo -e "${GREEN}[Nat Agentic] Already up to date!${NC}"
    exit 0
fi

echo -e "${YELLOW}[Nat Agentic] Updating to v${LATEST_VERSION}...${NC}"

# Detect installation method and update
if command -v npm &> /dev/null && npm list -g @nat-agentic/cli &> /dev/null 2>&1; then
    echo "Updating via NPM..."
    npm update -g @nat-agentic/cli
elif command -v brew &> /dev/null && brew list nat-agentic &> /dev/null 2>&1; then
    echo "Updating via Homebrew..."
    brew upgrade nat-agentic
elif command -v scoop &> /dev/null && scoop list 2>/dev/null | grep -q "nat-agentic"; then
    echo "Updating via Scoop..."
    scoop update nat-agentic
else
    echo "Running curl installer..."
    curl -fsSL https://nat-agentic.dev/install.sh | bash
fi

echo -e "${GREEN}[Nat Agentic] Update complete!${NC}"
echo -e "${GREEN}Previous: v${CURRENT_VERSION}${NC}"
echo -e "${GREEN}Current:  v${LATEST_VERSION}${NC}"
