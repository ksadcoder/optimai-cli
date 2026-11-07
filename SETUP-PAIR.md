# SETUP-PAIR.md — temporary Co-authored-by tooling

This is a **temporary**, self-contained addition (5 files, nothing else was
touched) that automatically appends `Co-authored-by:` trailers to commits so
merged PRs earn Pair Extraordinaire credit.

**What was added — and nothing else:**

| File | Purpose |
|---|---|
| `.coauthors` | one co-author per line, format `Name <id+username@users.noreply.github.com>` (fill the 3 lines with real values) |
| `.githooks/prepare-commit-msg` | POSIX sh hook: appends one `Co-authored-by:` trailer per `.coauthors` entry (idempotent, skips merge/squash/rebase, no-ops on missing/empty `.coauthors`, never blocks or breaks `--amend`) |
| `scripts/setup-git.sh` | `chmod +x` the hook + `git config core.hooksPath .githooks` + verification; `--uninstall` flag unsets `core.hooksPath` |
| `.github/workflows/coauthor-check.yml` | PR check: each PR must have ≥ 1 commit carrying `Co-authored-by:` (distinct name, read-only permissions, coexists with existing workflows) |
| `SETUP-PAIR.md` | this file |

## ACTIVATE

```bash
bash scripts/setup-git.sh
```

Then every new normal commit (`git commit -m ...` or via editor) carries all
three trailers automatically. Use `git commit --amend` to re-add to an
existing commit. If `core.hooksPath` is not activated, the hook simply never
runs — commits stay untouched.

## REMOVE EVERYTHING

```bash
bash scripts/setup-git.sh --uninstall
git config --unset core.hooksPath
```

Then delete the files:

```bash
git config --unset core.hooksPath
rm -rf .githooks .coauthors scripts/setup-git.sh SETUP-PAIR.md
git rm .github/workflows/coauthor-check.yml
git commit -m "chore: remove temporary coauthor tooling"
```

(The explicit `git config --unset` twice is harmless — the second is a
no-op; keep it to be sure even if `--uninstall` was skipped.)
