#!/usr/bin/env python3
"""
Security Check Script for Nat Agentic

Checks for common security vulnerabilities:
- SQL injection patterns
- XSS vulnerabilities
- Hardcoded secrets/credentials
- Command injection
- Path traversal
"""

import re
import sys
import json
from typing import List, Dict, Tuple

# Security patterns to detect
PATTERNS = {
    "sql_injection": [
        (r"execute\s*\(\s*[\"'].*\+.*[\"']", "Possible SQL injection: string concatenation in execute()"),
        (r"cursor\.execute\s*\(\s*[\"'].*%s.*[\"']\s*%\s*\(", "Possible SQL injection: string formatting in query"),
        (r"query\s*\(\s*[\"'].*\+.*[\"']", "Possible SQL injection: string concatenation in query"),
        (r"\.raw\s*\(\s*[\"'].*\+.*[\"']", "Possible SQL injection: string concatenation in raw query"),
    ],
    "xss": [
        (r"innerHTML\s*=\s*[^\"']", "Possible XSS: innerHTML with dynamic content"),
        (r"document\.write\s*\(", "Possible XSS: document.write usage"),
        (r"dangerouslySetInnerHTML", "Possible XSS: React dangerouslySetInnerHTML"),
        (r"v-html\s*=\s*\"", "Possible XSS: Vue v-html directive"),
    ],
    "secrets": [
        (r"password\s*=\s*[\"'][^\"']+[\"']", "Hardcoded password detected"),
        (r"api[_-]?key\s*=\s*[\"'][^\"']+[\"']", "Hardcoded API key detected"),
        (r"secret[_-]?key\s*=\s*[\"'][^\"']+[\"']", "Hardcoded secret key detected"),
        (r"aws[_-]?access[_-]?key[_-]?id\s*=\s*[\"'][A-Z0-9]{20}[\"']", "AWS access key detected"),
        (r"aws[_-]?secret[_-]?access[_-]?key\s*=\s*[\"'][A-Za-z0-9/+=]{40}[\"']", "AWS secret key detected"),
        (r"-----BEGIN\s+(RSA\s+)?PRIVATE\s+KEY-----", "Private key detected"),
        (r"github[_-]?token\s*=\s*[\"']ghp_[A-Za-z0-9]{36}[\"']", "GitHub token detected"),
    ],
    "command_injection": [
        (r"exec\s*\(\s*[\"'].*\+.*[\"']", "Possible command injection: exec with concatenation"),
        (r"system\s*\(\s*[\"'].*\+.*[\"']", "Possible command injection: system with concatenation"),
        (r"subprocess\..*shell\s*=\s*True", "Possible command injection: shell=True in subprocess"),
        (r"eval\s*\(", "Possible code injection: eval usage"),
    ],
    "path_traversal": [
        (r"\.\./", "Possible path traversal: ../ detected"),
        (r"open\s*\(\s*[\"'].*\+.*[\"']", "Possible path traversal: dynamic file path"),
    ]
}

def check_content(content: str, file_path: str) -> List[Dict]:
    """Check content for security issues."""
    issues = []

    for category, patterns in PATTERNS.items():
        for pattern, message in patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                # Get line number
                line_num = content[:match.start()].count('\n') + 1
                issues.append({
                    "category": category,
                    "message": message,
                    "file": file_path,
                    "line": line_num,
                    "match": match.group()[:100]  # Truncate long matches
                })

    return issues

def format_output(issues: List[Dict]) -> str:
    """Format issues for output."""
    if not issues:
        return json.dumps({"status": "ok", "issues": []})

    output = []
    output.append("=" * 60)
    output.append("NAT SECURITY CHECK")
    output.append("=" * 60)
    output.append(f"\nFound {len(issues)} potential security issue(s):\n")

    for i, issue in enumerate(issues, 1):
        output.append(f"{i}. [{issue['category'].upper()}] {issue['message']}")
        output.append(f"   File: {issue['file']}:{issue['line']}")
        output.append(f"   Match: {issue['match']}")
        output.append("")

    output.append("=" * 60)
    output.append("Please review and fix these issues before proceeding.")
    output.append("=" * 60)

    return json.dumps({
        "status": "warning",
        "issues": issues,
        "message": "\n".join(output)
    })

def main():
    """Main entry point."""
    import argparse

    parser = argparse.ArgumentParser(description="Security check for code")
    parser.add_argument("--file", required=True, help="File path being checked")
    parser.add_argument("--content", required=True, help="Content to check")

    args = parser.parse_args()

    # Decode content if needed
    try:
        content = args.content
        # Handle escaped characters
        content = content.encode().decode('unicode_escape')
    except:
        content = args.content

    issues = check_content(content, args.file)
    print(format_output(issues))

    # Exit with warning code if issues found
    sys.exit(1 if issues else 0)

if __name__ == "__main__":
    main()
