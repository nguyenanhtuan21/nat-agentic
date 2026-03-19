---
name: nat-test
description: Run tests with coverage reporting
allowed-tools: [Bash, Read]
---

# Nat Test

Run tests with coverage reporting for your project.

## Supported Test Runners

| Language | Runner | Config Files |
|----------|--------|--------------|
| JavaScript/TypeScript | Jest, Vitest | jest.config.*, vitest.config.* |
| Python | Pytest, unittest | pytest.ini, pyproject.toml |
| Go | go test | *_test.go |
| Rust | cargo test | Cargo.toml |
| Java | JUnit, Maven | pom.xml |

## Steps

1. Detect test framework
2. Run tests with coverage
3. Display results and coverage
4. Identify failing tests

## Execution

```bash
# Detect and run tests

# JavaScript/TypeScript
if [[ -f "package.json" ]]; then
    # Check for Jest
    if grep -q '"jest"' package.json || [[ -f "jest.config.js" ]]; then
        npm test -- --coverage
    # Check for Vitest
    elif grep -q '"vitest"' package.json || [[ -f "vitest.config.ts" ]]; then
        npx vitest run --coverage
    else
        npm test
    fi

# Python
elif [[ -f "pytest.ini" ]] || [[ -f "pyproject.toml" ]]; then
    pytest --cov=. --cov-report=term-missing

# Go
elif [[ -f "go.mod" ]]; then
    go test ./... -coverprofile=coverage.out
    go tool cover -func=coverage.out

# Rust
elif [[ -f "Cargo.toml" ]]; then
    cargo test
    cargo tarpaulin --out Stdout 2>/dev/null || cargo test
fi
```

## Output

```
╔═══════════════════════════════════════════════════════════╗
║                     NAT TEST                               ║
╠═══════════════════════════════════════════════════════════╣
║  Test Runner: Jest                                         ║
║  Coverage: 85.3%                                           ║
║                                                            ║
║  Test Suites: 12 passed, 12 total                          ║
║  Tests:       48 passed, 48 total                          ║
║  Snapshots:   0 total                                      ║
║  Time:        3.456 s                                      ║
║                                                            ║
║  Coverage Breakdown:                                       ║
║    Statements:  87.5% (234/267)                            ║
║    Branches:    78.2% (89/114)                             ║
║    Functions:   91.2% (52/57)                              ║
║    Lines:       85.3% (198/232)                            ║
║                                                            ║
║  Uncovered Files:                                          ║
║    src/legacy/old-api.ts (45%)                             ║
║    src/utils/debug.ts (62%)                                ║
╚═══════════════════════════════════════════════════════════╝
```

## Options

```bash
# Run specific test file
/nat-test src/auth/login.test.ts

# Run tests matching pattern
/nat-test --grep "authentication"

# Run with watch mode
/nat-test --watch

# Update snapshots
/nat-test --update-snapshots

# Run only changed files
/nat-test --changed
```
