---
name: nat-pr
description: Create a pull request with automatic title and body generation
allowed-tools: [Bash, Read, Grep]
---

# Nat PR

Create a pull request with an auto-generated description.

## Steps

1. Check current branch
2. Ensure branch is pushed to remote
3. Analyze commits for PR title
4. Generate PR description from commits
5. Create PR using `gh` CLI

## Execution

```bash
# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required. Install from: https://cli.github.com"
    exit 1
fi

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure branch is pushed
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    echo "Branch not pushed to remote. Pushing first..."
    git push -u origin $BRANCH
fi

# Get commits since main
COMMITS=$(git log origin/main..HEAD --oneline)

# Get PR title from first commit
TITLE=$(git log origin/main..HEAD --pretty=format:"%s" | head -1)

# Generate PR body
cat << 'EOF'
## Summary

[Brief description of changes]

## Changes

- [List of changes from commits]

## Test Plan

- [ ] Manual testing completed
- [ ] Unit tests added/updated
- [ ] Integration tests passing

## Screenshots (if applicable)

[Add screenshots here]

---

🤖 Generated with [Nat Agentic](https://nat-agentic.dev)
EOF

# Create PR
gh pr create --title "$TITLE" --body-file - --base main
```

## PR Template

```markdown
## Summary

[Auto-generated from commit messages]

## Changes

- feat(auth): add OAuth login support
- test(auth): add OAuth tests
- docs(auth): update README with OAuth instructions

## Test Plan

- [ ] Manual testing completed
- [ ] Unit tests added/updated
- [ ] All tests passing

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings introduced

---

🤖 Generated with [Nat Agentic](https://nat-agentic.dev)
```

## Output

```
╔═══════════════════════════════════════════════════════════╗
║                      NAT PR                                ║
╠═══════════════════════════════════════════════════════════╣
║  Branch: feature/oauth-login → main                        ║
║                                                            ║
║  Title: feat(auth): add OAuth login support                ║
║                                                            ║
║  Commits included:                                         ║
║    abc1234 feat(auth): add OAuth login support             ║
║    def5678 test(auth): add OAuth tests                     ║
║                                                            ║
║  Creating PR...                                            ║
║  ✓ PR created: https://github.com/owner/repo/pull/123      ║
╚═══════════════════════════════════════════════════════════╝
```
