---
name: nat-config
description: Open or display Nat Agentic configuration
allowed-tools: [Bash, Read, Edit]
---

# Nat Agentic Configuration

Open the configuration file for editing or display current settings.

## Usage

- `/nat-config` - Display current configuration
- `/nat-config edit` - Open in editor
- `/nat-config set <key> <value>` - Set a configuration value
- `/nat-config get <key>` - Get a configuration value

## Configuration File Location

```
~/.nat-agentic/config/settings.json
```

## Display Configuration

Read and pretty-print the configuration file:

```bash
# Display configuration
cat ${NAT_AGENTIC_HOME:-~/.nat-agentic}/config/settings.json | jq .
```

## Edit Configuration

Open in the user's preferred editor:

```bash
# Try VS Code first, then fall back to nano/vim
if command -v code &> /dev/null; then
    code ${NAT_AGENTIC_HOME:-~/.nat-agentic}/config/settings.json
elif command -v nano &> /dev/null; then
    nano ${NAT_AGENTIC_HOME:-~/.nat-agentic}/config/settings.json
else
    vim ${NAT_AGENTIC_HOME:-~/.nat-agentic}/config/settings.json
fi
```

## Output Format

```
╔═══════════════════════════════════════════════════════════╗
║               NAT AGENTIC CONFIGURATION                   ║
╠═══════════════════════════════════════════════════════════╣
║  File: ~/.nat-agentic/config/settings.json                ║
╠═══════════════════════════════════════════════════════════╣
║  {                                                         ║
║    "permissions": { ... },                                 ║
║    "marketplace": { ... },                                 ║
║    "branding": { ... },                                    ║
║    "profiles": { ... }                                     ║
║  }                                                         ║
╚═══════════════════════════════════════════════════════════╝
```
