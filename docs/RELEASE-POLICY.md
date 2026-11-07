# Release Policy

This document outlines versioning conventions, stability guarantees, and release cadences for `optimai-cli` (OptimAI Telegram Node).

## Semantic Versioning (SemVer 2.0)

We follow standard `MAJOR.MINOR.PATCH` versioning:
- **MAJOR (`X.0.0`)**: Breaking configuration changes, removed commands, or incompatible CLI protocol shifts requiring manual intervention.
- **MINOR (`1.X.0`)**: Backwards-compatible features, new Telegram bot commands, new diagnostic tools, or deployment templates.
- **PATCH (`1.0.X`)**: Bug fixes, supervisor backoff tuning, documentation improvements, security patches, and minor upstream CLI compatibility adjustments.

## Release Cadence

- **Patch Releases**: As-needed basis when bug fixes or upstream CLI changes are verified.
- **Minor Releases**: Scheduled upon completion of planned milestones in [ROADMAP.md](ROADMAP.md).
- **Security Hotfixes**: Released within 24 hours of triage and verification.

## Release Checklist

1. Verify all tests pass locally and in CI: `make test`.
2. Update [CHANGELOG.md](../CHANGELOG.md) with merged changes under the new version header.
3. Bump version string in `bot/__init__.py` or version constant.
4. Create an annotated git tag: `git tag -a v1.X.X -m "Release v1.X.X"`.
5. Push tag to origin and draft release notes with key highlights and upgrade instructions.

## Deprecation Policy

When an environment variable, command, or feature is marked for deprecation:
1. It will emit a deprecation warning in bot logs for at least one minor release cycle.
2. An alternative path will be documented in [UPGRADING.md](UPGRADING.md).
3. The feature will be removed in the subsequent major version.
