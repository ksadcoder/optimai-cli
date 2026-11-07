# OptimAI Telegram Node — light local commands only.
# Heavy work (docker build, 80-check suite on CI) stays on GitHub runners.

SHELL := /bin/bash
PY := .venv/bin/python

.PHONY: help venv install test pytest compile check status clean compose-config

help:
	@echo "targets:"
	@echo "  make venv            create Python 3.12 venv (uv)"
	@echo "  make install         install runtime + dev deps into .venv"
	@echo "  make test            run standalone smoke suite (no network)"
	@echo "  make pytest          run pytest test runner"
	@echo "  make compile         byte-compile bot/*.py"
	@echo "  make check           run compile + smoke tests"
	@echo "  make clean           remove bytecode caches"
	@echo "  make compose-config  validate docker-compose.yml with a dummy .env"

venv:
	uv venv --python 3.12 .venv

install:
	uv pip install --python .venv/bin/python -r requirements.txt -r requirements-dev.txt

test:
	$(PY) tests/smoke_test.py

pytest:
	$(PY) -m pytest tests/

compile:
	$(PY) -m py_compile bot/*.py

check: compile test

clean:
	find . -name __pycache__ -type d -not -path "./.git/*" -not -path "./.venv/*" -exec rm -rf {} +

compose-config:
	cp .env.example .env
	sed -i "s/^TELEGRAM_BOT_TOKEN=$/TELEGRAM_BOT_TOKEN=000:dummy/" .env
	sed -i "s/^TELEGRAM_ALLOWED_IDS=$/TELEGRAM_ALLOWED_IDS=123456789/" .env
	docker compose config > /dev/null
	rm .env

clean:
	rm -rf __pycache__ bot/__pycache__ tests/__pycache__ .pytest_cache .coverage

diag:
	bash scripts/system-info.sh

validate:
	.venv/bin/python -m py_compile bot/*.py
	.venv/bin/python tests/smoke_test.py

help:
	@echo "Available Makefile targets:"
	@echo "  check      - Run bytecode compilation and smoke test suite"
	@echo "  pytest     - Run pytest harness"
	@echo "  clean      - Remove bytecode and cache artifacts"
	@echo "  diag       - Run system diagnostic script"
	@echo "  validate   - Compile and execute validation checks"

git-status:
	bash scripts/check-git-clean.sh

help-all:
	@echo "OptimAI CLI Developer Commands:"
	@echo "  make check      - Bytecode + smoke test suite"
	@echo "  make pytest     - Run pytest test suite"
	@echo "  make clean      - Clean cache and temp files"
	@echo "  make diag       - Run host diagnostics"

check-all:
	make check
	bash scripts/check-git-clean.sh
