# Nat Agentic Plugins

Nat Agentic comes with 4 bundled plugins that enhance your development workflow.

## Plugin Overview

| Plugin | Category | Required | Description |
|--------|----------|----------|-------------|
| nat-core | Core | Yes | Branding, version, and configuration |
| nat-git-workflow | Productivity | No | Git commands with validation |
| nat-security | Security | No | Security validation hooks |
| nat-code-quality | Quality | No | Linting, testing, and review |

---

## nat-core (Required)

The core plugin provides essential functionality for Nat Agentic.

### Commands

#### `/nat`
Display Nat Agentic branding, version, and configuration info.

```
/nat
```

Output:
```
╔═══════════════════════════════════════════════════════════╗
║                    NAT AGENTIC                             ║
╠═══════════════════════════════════════════════════════════╣
║  Version:     1.0.0                                       ║
║  Home:        ~/.nat-agentic                              ║
║  Settings:    ~/.nat-agentic/config/settings.json         ║
╚═══════════════════════════════════════════════════════════╝
```

#### `/nat-update`
Update Nat Agentic to the latest version.

```
/nat-update
```

#### `/nat-config`
Open or manage configuration.

```
/nat-config          # Display current config
/nat-config edit     # Open in editor
/nat-config get key  # Get specific value
/nat-config set key value  # Set value
```

### Skills

#### `nat-defaults`
Default coding standards and conventions. This skill is automatically applied when writing code.

---

## nat-git-workflow

Streamlined git commands with validation hooks.

### Commands

#### `/nat-commit`
Create a commit with auto-generated message.

```
/nat-commit
```

Features:
- Analyzes staged changes
- Generates conventional commit message
- Adds co-authorship

#### `/nat-push`
Push with pre-push validation.

```
/nat-push
```

Validations:
- Runs tests (if available)
- Runs linter (if available)
- Warns about protected branches

#### `/nat-pr`
Create a pull request.

```
/nat-pr
```

Features:
- Auto-generates PR title from commits
- Creates PR description template
- Uses `gh` CLI

### Hooks

**Pre-push validation** - Automatically runs before `git push`:
- Test execution
- Lint checking
- Branch protection warning

---

## nat-security

Security validation to prevent common vulnerabilities.

### Hooks

**PreToolUse for Edit/Write** - Scans code before writing:

Checks for:
- SQL injection patterns
- XSS vulnerabilities
- Hardcoded secrets/credentials
- Command injection
- Path traversal

### Example Warning

```
╔═══════════════════════════════════════════════════════════╗
║                 NAT SECURITY CHECK                         ║
╠═══════════════════════════════════════════════════════════╣
║  Found 1 potential security issue(s):                      ║
║                                                            ║
║  1. [SECRETS] Hardcoded API key detected                   ║
║     File: src/api/client.ts:45                             ║
║     Match: apiKey = "sk-12345..."                          ║
║                                                            ║
║  Please review and fix these issues before proceeding.     ║
╚═══════════════════════════════════════════════════════════╝
```

---

## nat-code-quality

Code quality commands for linting, testing, and review.

### Commands

#### `/nat-lint`
Run linter with auto-fix options.

```
/nat-lint              # Run linter
/nat-lint --fix        # Auto-fix issues
/nat-lint --dry-run    # Show what would be fixed
```

Supported linters:
- ESLint (JavaScript/TypeScript)
- Pylint, Ruff (Python)
- golangci-lint (Go)
- Clippy (Rust)

#### `/nat-test`
Run tests with coverage.

```
/nat-test                    # Run all tests
/nat-test src/auth.test.ts   # Run specific file
/nat-test --grep "auth"      # Run matching tests
/nat-test --watch            # Watch mode
```

Supported test runners:
- Jest, Vitest (JavaScript/TypeScript)
- Pytest (Python)
- go test (Go)
- cargo test (Rust)

#### `/nat-review`
Perform code review.

```
/nat-review              # Review staged changes
/nat-review src/auth.ts  # Review specific file
/nat-review --branch main # Review vs branch
```

### Agents

#### `code-reviewer`
Specialized agent for comprehensive code reviews.

Review checklist:
- Code quality and patterns
- Security vulnerabilities
- Performance issues
- Test coverage
- Documentation

---

## Plugin Development

Want to create your own plugin? See the [Plugin Development Guide](https://nat-agentic.dev/docs/plugin-development).

### Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json    # Required
├── commands/          # Slash commands
├── agents/            # Subagent definitions
├── skills/            # Agent skills
└── hooks/
    └── hooks.json     # Event hooks
```
