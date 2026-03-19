---
name: nat-lint
description: Run linting with auto-fix options for various languages
allowed-tools: [Bash, Read, Edit]
---

# Nat Lint

Run linting tools with auto-fix capabilities for your project.

## Supported Linters

| Language | Linter | Config Files |
|----------|--------|--------------|
| JavaScript/TypeScript | ESLint | .eslintrc.*, eslint.config.* |
| Python | Pylint, Ruff | .pylintrc, ruff.toml |
| Go | golangci-lint | .golangci.yml |
| Rust | Clippy | .clippy.toml |
| Java | Checkstyle | checkstyle.xml |

## Steps

1. Detect project type and linter
2. Run linter with appropriate options
3. Show summary of issues
4. Optionally auto-fix issues

## Execution

```bash
# Detect project type
if [[ -f "package.json" ]]; then
    echo "JavaScript/TypeScript project detected"

    # Check for ESLint
    if [[ -f ".eslintrc.js" ]] || [[ -f ".eslintrc.json" ]] || [[ -f "eslint.config.js" ]]; then
        echo "Running ESLint..."

        # Run with auto-fix
        npx eslint . --ext .js,.jsx,.ts,.tsx --fix

        # Or just check
        npx eslint . --ext .js,.jsx,.ts,.tsx
    fi

elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
    echo "Python project detected"

    # Check for Ruff
    if command -v ruff &> /dev/null; then
        ruff check . --fix
    # Or Pylint
    elif command -v pylint &> /dev/null; then
        pylint **/*.py
    fi

elif [[ -f "go.mod" ]]; then
    echo "Go project detected"
    golangci-lint run ./...

elif [[ -f "Cargo.toml" ]]; then
    echo "Rust project detected"
    cargo clippy -- -D warnings
fi
```

## Output

```
╔═══════════════════════════════════════════════════════════╗
║                     NAT LINT                               ║
╠═══════════════════════════════════════════════════════════╣
║  Project: TypeScript (ESLint)                              ║
║                                                            ║
║  Issues Found: 5                                           ║
║    ⚠ src/auth/login.ts:12 - Unused variable 'token'        ║
║    ⚠ src/api/client.ts:45 - Missing return type           ║
║    ⚠ src/utils/format.ts:8 - Prefer const over let        ║
║    ✓ Fixed: 2 issues                                       ║
║    ✗ Manual fix needed: 3 issues                           ║
║                                                            ║
║  Summary:                                                  ║
║    Files checked: 23                                       ║
║    Errors: 0                                               ║
║    Warnings: 5                                             ║
║    Fixed: 2                                                ║
╚═══════════════════════════════════════════════════════════╝
```

## Auto-fix Options

```bash
# Fix all auto-fixable issues
/nat-lint --fix

# Fix only specific rules
/nat-lint --fix-rules semi,no-unused-vars

# Dry run (show what would be fixed)
/nat-lint --dry-run
```
