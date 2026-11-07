# OptimAI Telegram Node — light local commands only.
# Heavy work (docker build, 80-check suite on CI) stays on GitHub runners.

SHELL := /bin/bash
PY := .venv/bin/python

.PHONY: help venv install test compile clean compose-config delete-comms

help:
	@echo "targets:"
	@echo "  make venv            create Python 3.12 venv (uv)"
	@echo "  make install         install runtime + dev deps into .venv"
	@echo "  make test            run the standalone smoke suite (no network)"
	@echo "  make compile         byte-compile bot/*.py"
	@echo "  make clean           remove bytecode caches"
	@echo "  make compose-config  validate docker-compose.yml with a dummy .env"

venv:
	uv venv --python 3.12 .venv

install:
	uv pip install --python .venv/bin/python -r requirements.txt -r requirements-dev.txt

test:
	$(PY) tests/smoke_test.py

compile:
	$(PY) -m py_compile bot/*.py

clean:
	find . -name __pycache__ -type d -not -path './.git/*' -not -path './.venv/*' -exec rm -rf {} +

compose-config:
	cp .env.example .env
	sed -i 's/^TELEGRAM_BOT_TOKEN=$/TELEGRAM_BOT_TOKEN=000:dummy/' .env
	sed -i 's/^TELEGRAM_ALLOWED_IDS=$/TELEGRAM_ALLOWED_IDS=123456789/' .env
	docker compose config > /dev/null
	rm .env
