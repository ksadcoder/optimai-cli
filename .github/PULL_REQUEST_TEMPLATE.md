<!--
Thank you for the PR! Keep it small and focused: one feature or one fix.
CI must be green before merge (see .github/workflows/ci.yml).
-->

## What does this PR do?

<!-- one or two sentences -->

## Related issue (if any)

<!-- Fixes #N -->

## Checklist

- [ ] `python -m py_compile bot/*.py` passes
- [ ] `pytest` passes (wraps the 80-check smoke suite)
- [ ] Works honestly on both tracks: VPS with Docker AND Railway without
- [ ] No secrets committed (`.env` stays gitignored)
- [ ] Conventional commit message (`feat:` / `fix:` / `docs:` / `test:`)
