# SPDX-License-Identifier: Apache-2.0
"""Pytest wrapper around the standalone smoke suite.

The committed suite (`tests/smoke_test.py`) is the single source of truth —
it runs without network and without real Telegram (OPTIMAI_BIN -> the stub).
This wrapper keeps full granularity inside the suite itself while making
pytest/CI treat it as one gated test: exit code 0 AND the parsed RESULT line
must show zero failures and >= 36 passing checks.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys

import pytest

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SUITE = os.path.join(HERE, "smoke_test.py")
MIN_CHECKS = 36


def test_smoke_suite_passes() -> None:
    proc = subprocess.run(
        [sys.executable, SUITE],
        cwd=ROOT,
        capture_output=True,
        text=True,
        timeout=300,
    )
    if proc.returncode != 0:
        # surface the failing checks inside the pytest report
        pytest.fail(
            f"smoke suite exited {proc.returncode}\n"
            f"{proc.stdout[-4000:]}\n{proc.stderr[-2000:]}"
        )

    match = re.search(r"RESULT: (\d+)/(\d+) PASS, (\d+) FAIL", proc.stdout)
    assert match, f"RESULT line not found in suite output:\n{proc.stdout[-2000:]}"
    passed, total, failed = (int(g) for g in match.groups())

    assert failed == 0, f"{failed} failing checks (see stdout above)"
    assert passed >= MIN_CHECKS, f"only {passed}/{MIN_CHECKS}+ checks present"
