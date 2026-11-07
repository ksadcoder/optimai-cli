#!/bin/sh
# setup-git.sh — TEMPORARY: wires the .githooks/prepare-commit-msg hook
#   - bash scripts/setup-git.sh             -> activate
#   - bash scripts/setup-git.sh --uninstall -> deactivate
# Full removal instructions live in SETUP-PAIR.md.

set -eu

if [ "${1:-}" = "--uninstall" ]; then
  if git config --unset core.hooksPath 2>/dev/null; then
    echo "uninstall: core.hooksPath unset (hook no longer runs)"
  else
    echo "uninstall: core.hooksPath was not set — nothing to do"
  fi
  echo "reminder: files .githooks/ .coauthors scripts/setup-git.sh "
  echo "SETUP-PAIR.md and .github/workflows/coauthor-check.yml still "
  echo "exist on disk — see SETUP-PAIR.md 'REMOVE EVERYTHING' to delete."
  exit 0
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

[ -f .githooks/prepare-commit-msg ] || {
  echo "ERROR: .githooks/prepare-commit-msg not found in $root" >&2
  exit 1
}

chmod +x .githooks/prepare-commit-msg
git config core.hooksPath .githooks

echo "activated."
echo "verification:"
echo "  core.hooksPath = $(git config core.hooksPath)"
if [ -x .githooks/prepare-commit-msg ]; then
  echo "  .githooks/prepare-commit-msg: executable"
else
  echo "  WARNING: hook not executable (this should not happen)" >&2
fi
if [ -f .coauthors ]; then
  n=$(grep -cve'^$' .coauthors || true)
  if [ -n "$n" ] && [ "$n" -gt 0 ]; then
    echo "  .coauthors: found with $n non-empty entr(ies)"
  else
    echo "  .coauthors exists but is EMPTY (hook will be a silent no-op)"
  fi
else
  echo "  WARNING: .coauthors missing — hook is a silent no-op"
fi
