---
name: nat-review
description: Perform code review on staged changes or specific files
allowed-tools: [Bash, Read, Grep, Glob]
---

# Nat Review

Perform a comprehensive code review on your changes.

## Usage

- `/nat-review` - Review staged changes
- `/nat-review <file>` - Review specific file
- `/nat-review --branch main` - Review changes compared to branch

## Review Checklist

### Code Quality
- [ ] Code is readable and well-organized
- [ ] Functions are small and focused
- [ ] Naming is clear and consistent
- [ ] No code duplication (DRY)

### Best Practices
- [ ] Error handling is appropriate
- [ ] Edge cases are handled
- [ ] No hardcoded values (use constants)
- [ ] Proper use of async/await

### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities

### Performance
- [ ] No N+1 queries
- [ ] Appropriate data structures
- [ ] No memory leaks
- [ ] Efficient algorithms

### Testing
- [ ] Tests are included
- [ ] Tests are meaningful
- [ ] Edge cases tested

## Execution

```bash
# Get diff to review
if [[ -n "$1" ]]; then
    # Review specific file
    git diff HEAD -- "$1"
elif git diff --cached --quiet; then
    # No staged changes, review working directory
    git diff HEAD
else
    # Review staged changes
    git diff --cached
fi
```

## Output Format

```
╔═══════════════════════════════════════════════════════════╗
║                    NAT CODE REVIEW                         ║
╠═══════════════════════════════════════════════════════════╣
║  Files Changed: 3                                          ║
║  Lines Added: +127                                         ║
║  Lines Removed: -23                                        ║
╠═══════════════════════════════════════════════════════════╣
║  📁 src/auth/login.ts                                      ║
║  ─────────────────────────────────────────────────────────║
║  ⚠ Line 45: Consider using optional chaining              ║
║    user.profile.name                                       ║
║    → user?.profile?.name                                   ║
║                                                            ║
║  💡 Line 78: Could extract to a helper function            ║
║    Complex validation logic could be simplified            ║
║                                                            ║
║  📁 src/api/client.ts                                      ║
║  ─────────────────────────────────────────────────────────║
║  ✓ Line 12: Good error handling                            ║
║  ✓ Line 34: Proper type annotations                        ║
║                                                            ║
║  🔒 Line 56: SECURITY - Possible hardcoded secret          ║
║    apiKey = "sk-12345..."                                  ║
║    → Use environment variable instead                      ║
╠═══════════════════════════════════════════════════════════╣
║  SUMMARY                                                   ║
║  ✗ Critical: 1 (security issue)                            ║
║  ⚠ Warnings: 2 (code quality)                              ║
║  💡 Suggestions: 3 (improvements)                          ║
║  ✓ Positive: 5 (good practices)                            ║
╚═══════════════════════════════════════════════════════════╝
```

## Review Severity Levels

| Level | Icon | Description |
|-------|------|-------------|
| Critical | 🔒 | Security vulnerabilities, data loss risk |
| Error | ✗ | Bugs, breaking changes |
| Warning | ⚠ | Code quality issues |
| Suggestion | 💡 | Improvement opportunities |
| Positive | ✓ | Good practices observed |
