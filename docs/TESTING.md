# Testing Strategy & Test Suite Guide

This document describes how `optimai-cli` is verified, its offline test strategy, and guidelines for adding new test coverage.

## Offline Architecture

The test suite is designed to run completely offline without real Telegram API credentials, without host Docker dependencies, and without a live OptimAI network connection.

Key architectural components of the test harness:
- **`scripts/stub-optimai-cli.sh`**: Deterministic bash stub that simulates all upstream `optimai-cli` subcommands (`auth status`, `auth login`, `node start`, `node stop`, `node status`, and `rewards balance`).
- **Fake Environment Injection**: Overrides `OPTIMAI_BIN`, `OPTIMAI_HOME`, and `DATA_DIR` into temporary directories created with `tempfile.mkdtemp()`.
- **Pure Logic Isolation**: Validates `bot.config`, `bot.gatekeeper`, and log parsing helpers without socket operations.
- **Subprocess & State Machine Verification**: Tests supervisor backoff, circuit breaking, and login session timeouts against real subshell processes.

## Running Tests Locally

```bash
# Run via pytest with virtual environment
.venv/bin/pytest tests/

# Run smoke test script directly
python3 tests/smoke_test.py

# Run via Makefile
make test
```

## Adding New Test Checks

Smoke tests are registered using the `check(name: str, cond: bool, info: str = "")` helper in `tests/smoke_test.py`:

```python
check(
    "config: example assertion name",
    some_condition_to_evaluate == expected_value,
    "optional failure details"
)
```

The suite requires at least 36 assertions to pass, currently covering over 80 discrete invariants across config, supervisor, gatekeeper, and CLI wrapper modules.
