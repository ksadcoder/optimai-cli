# Maintenance runbook — for the maintainer (mkr-infinity)

## How to add a new Telegram command (checklist)

1. `bot/main.py`: add `cmd_<name>` (reply with `_reply`/`_send_pre` helpers —
   they handle the 4096-char split and HTML escaping).
2. Register inside `register_handlers` BEFORE `/id` if admin-gated, or as the
   special `/id`-style open command -> then re-check the catch-all
   `unauthorized_handler` remains LAST in the group.
3. Add the command to `/help` and to the README §5 table.
4. Add a source-inspection check to `tests/smoke_test.py` (loop tuple).
5. `make compile && make test` (local, 3 s) — heavy CI runs on GitHub runners.

## How to release a version

1. Merge feature PRs to main (they deploy through the trailer campaign).
2. `CHANGELOG.md`: move entries from Unreleased/feat list into a dated block.
3. `bot/__init__.py`: bump `__version__` + the banner's version line.
4. Tag: `git tag -a vX.Y.Z -m "..." && git push origin vX.Y.Z` (manual, owner).
5. `docker compose up -d --build` on the VPS picks it up; Railway rebuilds via GitHub or `railway up`.

## Change watchpoints (what broke previous builds)

- `container's HOME` must stay on the volume (login loss otherwise)
- docker probe must use `run_bin` (never `optimai-cli docker` — that never existed)
- supervisor: never remove `_restart_scheduled` double-spawn guard
- `read_new_chunk` shrink check must be `<` (`<=` repeats old log lines)
- login cancel must pass the child handle (old code raised)
- handler order: unauthorized catch-all LAST, `/id` open-but-budgeted before it

## When the repo gets messy

- Branches left behind → delete on GitHub or `git push origin --delete <name>`
- Secret rotation → @BotFather /revoke, update `.env`, `docker compose up -d`
- Storage of `data/` → it holds live credentials; never commit, never wipe casually

## Removing the temporary coauthor tooling (when farming ends)

See SETUP-PAIR.md 'REMOVE EVERYTHING': unset hooksPath, delete the 5 files,
commit.
