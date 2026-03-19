---
name: nat
description: Display Nat Agentic branding, version, and configuration info
allowed-tools: [Bash, Read]
---

# Nat Agentic Info

You are part of **Nat Agentic**, a custom Claude Code distribution.

## Display Information

Show the following information to the user:

1. **Version**: Read the VERSION file and display current version
2. **Configuration Path**: Show `NAT_AGENTIC_HOME` and settings path
3. **Installed Plugins**: List all plugins in the marketplace
4. **Current Profile**: Show which profile is active

## Execution

```bash
# Read version
cat ${NAT_AGENTIC_HOME:-~/.nat-agentic}/VERSION 2>/dev/null || echo "1.0.0"

# Show configuration
echo "Home: ${NAT_AGENTIC_HOME:-~/.nat-agentic}"
echo "Settings: ${CLAUDE_SETTINGS_PATH}"

# List plugins
ls -la ${NAT_AGENTIC_HOME:-~/.nat-agentic}/marketplace/plugins/ 2>/dev/null
```

## Output Format

```
╔═══════════════════════════════════════════════════════════╗
║                    NAT AGENTIC                             ║
║              Custom Claude Code Distribution               ║
╠═══════════════════════════════════════════════════════════╣
║  Version:     1.0.0                                       ║
║  Home:        ~/.nat-agentic                              ║
║  Settings:    ~/.nat-agentic/config/settings.json         ║
║  Profile:     default                                     ║
╠═══════════════════════════════════════════════════════════╣
║  PLUGINS                                                   ║
║  ✓ nat-core (required)                                    ║
║  ✓ nat-git-workflow                                       ║
║  ✓ nat-security                                           ║
║  ✓ nat-code-quality                                       ║
╚═══════════════════════════════════════════════════════════╝
```
