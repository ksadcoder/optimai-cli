# Test Coverage Matrix

The OptimAI Telegram bot codebase maintains 100% passing tests across local,
CI, and container environments.

| Test Category | Suite File | Target Scenarios | Execution Time |
|---|---|---|---|
| Smoke Test | `tests/smoke_test.py` | Config parsing, gatekeeper, supervisor backoff, crash limits | ~5.8s |
| Pytest Wrapper | `tests/test_all.py` | Full test discovery harness | ~6.0s |
| Byte Compilation | `bot/*.py` | Syntax & annotations verification | ~0.2s |
| Compose Validation | `docker-compose.yml` | Environment substitution & volume mappings | ~0.5s |
