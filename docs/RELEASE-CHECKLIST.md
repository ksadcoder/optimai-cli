# Release Tagging and Verification Checklist

When cutting a new release of `optimai-telegram-node`:

- [ ] Ensure all PRs are merged to `main` with green CI.
- [ ] Run `make check` locally (all 86+ smoke tests pass).
- [ ] Verify `bot/__init__.py` has updated `__version__`.
- [ ] Update `CHANGELOG.md` with new features and fixes.
- [ ] Tag the release commit: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`.
- [ ] Push tags: `git push origin --tags`.
