---
name: nat-update
description: Update Nat Agentic to the latest version
allowed-tools: [Bash]
---

# Update Nat Agentic

Check for and install the latest version of Nat Agentic.

## Steps

1. Check current version
2. Fetch latest version from GitHub
3. Compare versions
4. If update available, download and install

## Execution

```bash
# Get current version
CURRENT=$(cat ${NAT_AGENTIC_HOME:-~/.nat-agentic}/VERSION 2>/dev/null || echo "1.0.0")

# Check for update method
if command -v npm &> /dev/null && npm list -g @nat-agentic/cli &> /dev/null; then
    echo "Updating via NPM..."
    npm update -g @nat-agentic/cli
elif command -v brew &> /dev/null && brew list nat-agentic &> /dev/null; then
    echo "Updating via Homebrew..."
    brew upgrade nat-agentic
elif command -v scoop &> /dev/null; then
    echo "Updating via Scoop..."
    scoop update nat-agentic
else
    echo "Running curl installer..."
    curl -fsSL https://nat-agentic.dev/install.sh | bash
fi
```

## Output

After update, display:
```
✓ Nat Agentic updated successfully!
  Previous: v1.0.0
  Current:  v1.1.0
```
