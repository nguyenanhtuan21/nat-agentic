# Nat Agentic Configuration

This guide covers all configuration options for Nat Agentic.

## Configuration Location

Configuration is stored in `~/.nat-agentic/config/settings.json`.

```bash
# View configuration
cat ~/.nat-agentic/config/settings.json

# Edit configuration
nat --nat-config
```

## Configuration Structure

```json
{
  "$schema": "https://claude.ai/schema/settings.json",
  "version": "1.0.0",
  "name": "Nat Agentic Default Settings",

  "permissions": { ... },
  "bashSandbox": { ... },
  "marketplace": { ... },
  "branding": { ... },
  "profiles": { ... },
  "hooks": { ... }
}
```

---

## Permissions

Control what tools Nat Agentic can use.

```json
{
  "permissions": {
    "allow": [
      "Read(**)",
      "Edit(**)",
      "Write(**)",
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(bun *)",
      "Glob(**)",
      "Grep(**)"
    ],
    "deny": [
      "Bash(rm -rf /*)",
      "Bash(sudo rm *)"
    ]
  }
}
```

### Permission Patterns

| Pattern | Description |
|---------|-------------|
| `Read(**)` | Allow reading all files |
| `Edit(src/**)` | Allow editing files in src/ |
| `Bash(git *)` | Allow all git commands |
| `Bash(npm run *)` | Allow npm run commands |

---

## Bash Sandbox

Configure bash execution restrictions.

```json
{
  "bashSandbox": {
    "enabled": true,
    "allowNetwork": true,
    "allowedDomains": [
      "api.anthropic.com",
      "github.com",
      "npmjs.org"
    ]
  }
}
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enabled` | boolean | true | Enable sandbox |
| `allowNetwork` | boolean | true | Allow network access |
| `allowedDomains` | array | [] | Whitelist of domains |

---

## Marketplace

Configure plugin marketplace settings.

```json
{
  "marketplace": {
    "enabled": true,
    "path": "${NAT_AGENTIC_HOME}/marketplace",
    "autoUpdate": true,
    "defaultPlugins": [
      "nat-core",
      "nat-git-workflow",
      "nat-security",
      "nat-code-quality"
    ]
  }
}
```

### Options

| Option | Type | Description |
|--------|------|-------------|
| `enabled` | boolean | Enable marketplace |
| `path` | string | Path to marketplace directory |
| `autoUpdate` | boolean | Auto-update plugins |
| `defaultPlugins` | array | Plugins to install by default |

---

## Branding

Customize Nat Agentic branding.

```json
{
  "branding": {
    "name": "Nat Agentic",
    "showBanner": true,
    "showVersion": true,
    "colors": {
      "primary": "#6366f1",
      "secondary": "#8b5cf6",
      "accent": "#10b981"
    }
  }
}
```

### Options

| Option | Type | Description |
|--------|------|-------------|
| `name` | string | Display name |
| `showBanner` | boolean | Show ASCII banner on start |
| `showVersion` | boolean | Show version in banner |
| `colors` | object | Brand colors (hex) |

---

## Profiles

Configure available profiles.

```json
{
  "profiles": {
    "current": "default",
    "available": ["default", "web-dev", "backend", "minimal"]
  }
}
```

### Switching Profiles

```bash
# Via CLI
nat --profile web-dev

# Via script
~/.nat-agentic/scripts/switch-profile.sh web-dev
```

---

## Hooks

Configure event hooks.

```json
{
  "hooks": {
    "enabled": true,
    "preload": [
      "${NAT_AGENTIC_HOME}/marketplace/plugins/nat-security/hooks/security-hooks.json"
    ]
  }
}
```

---

## Profiles

### Default Profile

Full-featured configuration with all plugins.

```json
{
  "name": "default",
  "permissions": {
    "allow": ["Read(**)", "Edit(**)", "Write(**)", "Bash(*)", "Glob(**)", "Grep(**)"]
  },
  "marketplace": {
    "defaultPlugins": ["nat-core", "nat-git-workflow", "nat-security", "nat-code-quality"]
  }
}
```

### Web Development Profile

Optimized for frontend/full-stack development.

```json
{
  "name": "web-dev",
  "env": {
    "NODE_ENV": "development"
  },
  "shortcuts": {
    "dev": "npm run dev",
    "build": "npm run build",
    "test": "npm test"
  }
}
```

### Backend Profile

Optimized for backend/API development.

```json
{
  "name": "backend",
  "permissions": {
    "allow": [
      "Read(**)", "Edit(**)", "Write(**)",
      "Bash(python *)", "Bash(pip *)", "Bash(go *)", "Bash(cargo *)"
    ]
  }
}
```

### Minimal Profile

Minimal configuration with only core plugin.

```json
{
  "name": "minimal",
  "marketplace": {
    "defaultPlugins": ["nat-core"]
  }
}
```

---

## Enterprise Configuration

For enterprise deployments, use `settings-enterprise.json`:

```json
{
  "name": "enterprise",
  "permissions": {
    "allow": [
      "Read(${WORKSPACE_ROOT}/**)",
      "Edit(${WORKSPACE_ROOT}/**)"
    ],
    "deny": [
      "Write(**/.env*)",
      "Bash(curl *)",
      "Bash(wget *)"
    ]
  },
  "bashSandbox": {
    "enabled": true,
    "allowNetwork": false
  },
  "audit": {
    "enabled": true,
    "logPath": "${NAT_AGENTIC_HOME}/logs/audit.log"
  }
}
```

### Enterprise Features

- Restricted file access
- Network isolation
- Audit logging
- Limited plugin installation

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NAT_AGENTIC_HOME` | Installation directory | `~/.nat-agentic` |
| `NAT_AGENTIC_VERSION` | Current version | From VERSION file |
| `CLAUDE_SETTINGS_PATH` | Settings file path | `$NAT_AGENTIC_HOME/config/settings.json` |
| `WORKSPACE_ROOT` | Workspace root (enterprise) | Current directory |

---

## Troubleshooting

### Reset Configuration

```bash
# Backup current config
cp ~/.nat-agentic/config/settings.json ~/.nat-agentic/config/settings.json.backup

# Reset to default
cp ~/.nat-agentic/config/settings-default.json ~/.nat-agentic/config/settings.json
```

### Debug Mode

```bash
# Enable debug logging
export NAT_DEBUG=true
nat
```

### View Logs

```bash
# View recent logs
tail -f ~/.nat-agentic/logs/nat-agentic.log
```
