---
name: nat-push
description: Push changes to remote with validation and branch protection
allowed-tools: [Bash]
---

# Nat Push

Push changes to remote repository with pre-push validation.

## Pre-push Validation

1. Run tests if available
2. Check for linting errors
3. Verify branch is not main/master (unless explicitly allowed)
4. Confirm push destination

## Steps

```bash
# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check branch protection
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo "⚠️  Warning: Pushing to protected branch: $BRANCH"
    echo "Consider creating a feature branch instead."
    # Ask for confirmation
fi

# Run tests if available
if [[ -f "package.json" ]] && grep -q '"test"' package.json; then
    echo "Running tests..."
    npm test || { echo "Tests failed. Fix before pushing."; exit 1; }
fi

# Run lint if available
if [[ -f "package.json" ]] && grep -q '"lint"' package.json; then
    echo "Running linter..."
    npm run lint || { echo "Lint errors found. Fix before pushing."; exit 1; }
fi

# Show commits to push
echo "Commits to push:"
git log origin/$BRANCH..HEAD --oneline 2>/dev/null || git log --oneline -5

# Push
git push -u origin $BRANCH
```

## Output

```
╔═══════════════════════════════════════════════════════════╗
║                     NAT PUSH                               ║
╠═══════════════════════════════════════════════════════════╣
║  Branch: feature/oauth-login                               ║
║  Remote: origin                                            ║
║                                                            ║
║  Commits to push:                                          ║
║    abc1234 feat(auth): add OAuth login support             ║
║    def5678 test(auth): add OAuth tests                     ║
║                                                            ║
║  Validation:                                               ║
║    ✓ Tests passed (12 tests)                               ║
║    ✓ Lint passed                                           ║
║                                                            ║
║  Pushing to origin/feature/oauth-login...                  ║
║  ✓ Push successful                                         ║
╚═══════════════════════════════════════════════════════════╝
```
