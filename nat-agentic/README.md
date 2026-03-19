# Nat Agentic

> Custom Claude Code Distribution with Curated Plugins and Marketplace

Nat Agentic is a customized distribution of [Claude Code](https://claude.ai/code) that provides an enhanced out-of-the-box experience with pre-configured plugins, custom branding, and multi-channel distribution support.

## Features

- 🚀 **Easy Installation** - Multiple installation methods (NPM, Homebrew, Scoop, Curl)
- 🔌 **Curated Plugins** - 4 default plugins for core functionality, git workflow, security, and code quality
- 🎨 **Custom Branding** - Personalized CLI experience with ASCII art banners
- ⚙️ **Profile System** - Pre-configured profiles for web dev, backend, and minimal setups
- 🔒 **Enterprise Ready** - Optional lockdown settings for enterprise environments

## Quick Start

### macOS / Linux

```bash
# Using curl (recommended)
curl -fsSL https://nat-agentic.dev/install.sh | bash

# Using Homebrew
brew tap nat-agentic/tap
brew install nat-agentic

# Using NPM
npm install -g @nat-agentic/cli
```

### Windows

```powershell
# Using PowerShell
irm https://nat-agentic.dev/install.ps1 | iex

# Using Scoop
scoop bucket add nat-agentic https://github.com/nat-agentic/scoop-bucket
scoop install nat-agentic
```

## Usage

```bash
# Start interactive session
nat

# Show Nat Agentic version
nat --nat-version

# Update Nat Agentic
nat --nat-update

# Open configuration
nat --nat-config

# Use a specific profile
nat --profile web-dev
```

## Bundled Plugins

### nat-core (Required)
Core plugin providing branding, version info, and configuration management.
- Commands: `/nat`, `/nat-update`, `/nat-config`
- Skill: `nat-defaults` for coding standards

### nat-git-workflow
Streamlined git commands with validation hooks.
- Commands: `/nat-commit`, `/nat-push`, `/nat-pr`
- Hooks: Pre-push validation

### nat-security
Security validation to prevent common vulnerabilities.
- Hooks: PreToolUse for Edit/Write operations
- Checks: SQL injection, XSS, command injection, secrets

### nat-code-quality
Code quality commands for linting, testing, and review.
- Commands: `/nat-lint`, `/nat-test`, `/nat-review`
- Agent: `code-reviewer`

## Profiles

| Profile | Description |
|---------|-------------|
| `web-dev` | Frontend/full-stack web development |
| `backend` | Backend/API development |
| `minimal` | Minimal configuration |

```bash
# Switch profile
nat --profile backend
```

## Configuration

Configuration files are stored in `~/.nat-agentic/`:

```
~/.nat-agentic/
├── config/
│   └── settings.json      # Main settings
├── marketplace/           # Plugin marketplace
└── profiles/              # Profile configurations
```

## Development

```bash
# Clone repository
git clone https://github.com/nat-agentic/nat-agentic.git
cd nat-agentic

# Run locally
./bin/nat
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Links

- [Documentation](https://nat-agentic.dev/docs)
- [Plugin Marketplace](https://nat-agentic.dev/marketplace)
- [GitHub](https://github.com/nat-agentic)
- [Changelog](./CHANGELOG.md)

---

Built with ❤️ by the Nat Agentic team
