#!/usr/bin/env bash
#
# Profile switcher for Nat Agentic
#

set -e

NAT_AGENTIC_HOME="${NAT_AGENTIC_HOME:-$HOME/.nat-agentic}"
PROFILES_DIR="$NAT_AGENTIC_HOME/config/profiles"
SETTINGS_FILE="$NAT_AGENTIC_HOME/config/settings.json"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo "Usage: switch-profile.sh <profile-name>"
    echo ""
    echo "Available profiles:"
    ls -1 "$PROFILES_DIR"/*.json 2>/dev/null | xargs -I {} basename {} .json || echo "  default"
    echo ""
    echo "Examples:"
    echo "  switch-profile.sh web-dev"
    echo "  switch-profile.sh backend"
    echo "  switch-profile.sh minimal"
}

# Check arguments
if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    usage
    exit 0
fi

PROFILE="$1"
PROFILE_FILE="$PROFILES_DIR/${PROFILE}.json"

# Check if profile exists
if [[ ! -f "$PROFILE_FILE" ]]; then
    # Try bundled profiles
    BUNDLED_PROFILE="$(dirname "$0")/../config/profiles/${PROFILE}.json"
    if [[ -f "$BUNDLED_PROFILE" ]]; then
        PROFILE_FILE="$BUNDLED_PROFILE"
    else
        echo -e "${RED}Error: Profile not found: ${PROFILE}${NC}"
        echo ""
        usage
        exit 1
    fi
fi

# Backup current settings
if [[ -f "$SETTINGS_FILE" ]]; then
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup"
fi

# Copy profile to settings
cp "$PROFILE_FILE" "$SETTINGS_FILE"

echo -e "${GREEN}[Nat Agentic] Switched to profile: ${PROFILE}${NC}"
echo -e "${BLUE}Configuration updated: ${SETTINGS_FILE}${NC}"
