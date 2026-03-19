# Getting Started with Nat Agentic

Welcome to Nat Agentic! This guide will help you get up and running quickly.

## What is Nat Agentic?

Nat Agentic is a custom distribution of Claude Code that provides:

- **Curated Plugins**: 4 pre-installed plugins for common development tasks
- **Custom Branding**: Personalized CLI experience
- **Profile System**: Pre-configured settings for different workflows
- **Multi-channel Distribution**: Install via NPM, Homebrew, Scoop, or curl

## Installation

### macOS / Linux

```bash
# Option 1: Curl (recommended)
curl -fsSL https://nat-agentic.dev/install.sh | bash

# Option 2: Homebrew
brew tap nat-agentic/tap
brew install nat-agentic

# Option 3: NPM
npm install -g @nat-agentic/cli
```

### Windows

```powershell
# Option 1: PowerShell
irm https://nat-agentic.dev/install.ps1 | iex

# Option 2: Scoop
scoop bucket add nat-agentic https://github.com/nat-agentic/scoop-bucket
scoop install nat-agentic

# Option 3: NPM
npm install -g @nat-agentic/cli
```

## First Run

After installation, start Nat Agentic:

```bash
nat
```

You'll see the Nat Agentic banner and be dropped into an interactive session.

## Basic Commands

| Command | Description |
|---------|-------------|
| `nat` | Start interactive session |
| `nat --help` | Show help |
| `nat --nat-version` | Show version |
| `nat --nat-config` | Open configuration |
| `nat --nat-update` | Update to latest version |
| `nat --profile <name>` | Use specific profile |

## Built-in Slash Commands

Nat Agentic includes several slash commands from the bundled plugins:

### Core Commands (nat-core)
- `/nat` - Display Nat Agentic info
- `/nat-update` - Update Nat Agentic
- `/nat-config` - Manage configuration

### Git Workflow (nat-git-workflow)
- `/nat-commit` - Create git commit with auto-generated message
- `/nat-push` - Push with validation
- `/nat-pr` - Create pull request

### Code Quality (nat-code-quality)
- `/nat-lint` - Run linter with auto-fix
- `/nat-test` - Run tests with coverage
- `/nat-review` - Code review for changes

## Profiles

Switch between pre-configured profiles:

```bash
# Use web development profile
nat --profile web-dev

# Use backend profile
nat --profile backend

# Use minimal profile (core plugin only)
nat --profile minimal
```

### Available Profiles

| Profile | Description | Plugins |
|---------|-------------|---------|
| `default` | Full-featured setup | All 4 plugins |
| `web-dev` | Frontend/full-stack | All 4 plugins |
| `backend` | Backend/API development | All 4 plugins |
| `minimal` | Minimal configuration | nat-core only |

## Configuration

Configuration is stored in `~/.nat-agentic/`:

```
~/.nat-agentic/
├── config/
│   └── settings.json      # Main settings
├── marketplace/
│   └── plugins/           # Installed plugins
├── logs/                  # Log files
└── VERSION                # Current version
```

### Editing Settings

```bash
# Open in editor
nat --nat-config

# Or edit directly
nano ~/.nat-agentic/config/settings.json
```

## Next Steps

- [Plugin Documentation](./plugins.md)
- [Configuration Guide](./configuration.md)
- [GitHub Repository](https://github.com/nat-agentic/nat-agentic)

## Getting Help

- Run `nat --help` for CLI options
- Visit [nat-agentic.dev/docs](https://nat-agentic.dev/docs)
- Open an issue on [GitHub](https://github.com/nat-agentic/nat-agentic/issues)
