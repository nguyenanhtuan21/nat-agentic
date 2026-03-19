#!/usr/bin/env bash
#
# Session start hook for Nat Agentic
# This script runs when a new Nat Agentic session starts
#

NAT_AGENTIC_HOME="${NAT_AGENTIC_HOME:-$HOME/.nat-agentic}"
NAT_AGENTIC_VERSION="${NAT_AGENTIC_VERSION:-$(cat "$NAT_AGENTIC_HOME/VERSION" 2>/dev/null || echo "1.0.0")}"

# Check for updates (silently)
# LATEST=$(curl -fsSL "https://api.github.com/repos/nat-agentic/nat-agentic/releases/latest" 2>/dev/null | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/' || echo "")

# if [[ -n "$LATEST" ]] && [[ "$NAT_AGENTIC_VERSION" != "$LATEST" ]]; then
#     echo "💡 A new version of Nat Agentic is available: v$LATEST"
#     echo "   Run 'nat --nat-update' to update."
# fi

# Load user's shell preferences
if [[ -f "$NAT_AGENTIC_HOME/config/shell-preferences.sh" ]]; then
    source "$NAT_AGENTIC_HOME/config/shell-preferences.sh"
fi

# Set up aliases
alias n='nat'
alias natc='nat --nat-config'
alias natu='nat --nat-update'

# Export useful environment variables
export NAT_SESSION_START=$(date +%s)
