#!/usr/bin/env bash
#
# Pre-push validation hook for Nat Agentic
# Runs tests and lint before allowing push
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[Nat Git] Running pre-push validation...${NC}"

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# Check for protected branches
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo -e "${RED}[Nat Git] Direct push to $BRANCH is not recommended.${NC}"
    echo "Consider using a feature branch and creating a PR instead."
fi

# Run tests if available
if [[ -f "package.json" ]]; then
    if grep -q '"test"' package.json 2>/dev/null; then
        echo -e "${YELLOW}[Nat Git] Running tests...${NC}"
        if npm test 2>/dev/null; then
            echo -e "${GREEN}[Nat Git] ✓ Tests passed${NC}"
        else
            echo -e "${RED}[Nat Git] ✗ Tests failed${NC}"
            exit 1
        fi
    fi

    if grep -q '"lint"' package.json 2>/dev/null; then
        echo -e "${YELLOW}[Nat Git] Running linter...${NC}"
        if npm run lint 2>/dev/null; then
            echo -e "${GREEN}[Nat Git] ✓ Lint passed${NC}"
        else
            echo -e "${RED}[Nat Git] ✗ Lint errors found${NC}"
            exit 1
        fi
    fi
fi

# Check for TODO/FIXME comments
TODO_COUNT=$(grep -r "TODO\|FIXME" --include="*.ts" --include="*.js" --include="*.py" . 2>/dev/null | wc -l || echo "0")
if [[ "$TODO_COUNT" -gt 0 ]]; then
    echo -e "${YELLOW}[Nat Git] Found $TODO_COUNT TODO/FIXME comments${NC}"
fi

echo -e "${GREEN}[Nat Git] Pre-push validation passed${NC}"
exit 0
