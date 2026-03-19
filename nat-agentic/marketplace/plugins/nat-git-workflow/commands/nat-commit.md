---
name: nat-commit
description: Create a git commit with automatic message generation and validation
allowed-tools: [Bash, Read, Grep]
---

# Nat Commit

Create a git commit following Nat Agentic conventions.

## Steps

1. Check for staged changes
2. Review diff for commit message suggestions
3. Validate commit message format
4. Create commit with co-authorship

## Pre-commit Checks

```bash
# Check if in git repository
git rev-parse --is-inside-work-tree || { echo "Not a git repository"; exit 1; }

# Check for staged changes
if git diff --cached --quiet; then
    echo "No staged changes. Stage files first:"
    echo "  git add <files>"
    exit 1
fi

# Show staged changes
git diff --cached --stat
```

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

Co-Authored-By: Nat Agentic <noreply@nat-agentic.dev>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, etc.)
- `refactor`: Code restructuring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

## Execution

```bash
# Analyze changes and generate commit message
git diff --cached

# Create commit
git commit -m "$(cat <<'EOF'
feat(scope): description of changes

Detailed explanation if needed.

Co-Authored-By: Nat Agentic <noreply@nat-agentic.dev>
EOF
)"
```

## Output

```
╔═══════════════════════════════════════════════════════════╗
║                    NAT COMMIT                              ║
╠═══════════════════════════════════════════════════════════╣
║  Staged Changes:                                          ║
║    M  src/auth/login.ts                                   ║
║    A  src/auth/oauth.ts                                   ║
║                                                            ║
║  Suggested Message:                                        ║
║    feat(auth): add OAuth login support                     ║
║                                                            ║
║  Commit created: abc1234                                   ║
╚═══════════════════════════════════════════════════════════╝
```
