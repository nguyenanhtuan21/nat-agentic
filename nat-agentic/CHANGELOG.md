# Changelog

All notable changes to Nat Agentic will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added
- Initial release of Nat Agentic
- CLI wrapper (`nat`) with custom branding
- 4 default plugins:
  - `nat-core`: Core branding and configuration commands
  - `nat-git-workflow`: Git workflow commands (/nat-commit, /nat-push, /nat-pr)
  - `nat-security`: Security validation hooks
  - `nat-code-quality`: Code quality commands (/nat-lint, /nat-test, /nat-review)
- Multi-channel distribution support:
  - NPM package: `@nat-agentic/cli`
  - Homebrew formula: `nat-agentic`
  - Scoop bucket: `nat-agentic`
  - Curl installer: `curl -fsSL https://nat-agentic.dev/install.sh | bash`
- Profile system for different development workflows
- Custom settings management with enterprise lockdown option
- ASCII art branding banner
