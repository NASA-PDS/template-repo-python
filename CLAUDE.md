# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is NASA-PDS's template repository for new Python projects. When working in a repo created from this template, the placeholder `your_package_name` must be replaced with the actual module name throughout `setup.cfg`, `src/pds/`, `tests/`, and other files.

## Commands

### Setup

```bash
python -m venv venv
source venv/bin/activate
pip install --editable '.[dev]'
```

Or via tox:

```bash
tox --devenv venv -e dev
```

### Testing

```bash
pytest                        # run all tests
pytest tests/path/test_foo.py # run a single test file
pytest -k "test_name"         # run a single test by name
ptw                           # watch mode
```

Tests run in parallel by default (`--numprocesses auto`) with coverage reporting to XML and terminal.

### Linting

```bash
tox -e lint                   # run all linters (flake8, mypy, pre-commit hooks)
flake8 src                    # flake8 only
mypy src                      # type-checking only
```

### Full build (tests + lint + docs)

```bash
tox
```

### Documentation

```bash
sphinx-build docs/source docs/build
# output at docs/build/index.html
```

### Build package

```bash
pip install build
python -m build .
```

### Secrets detection

```bash
scripts/detect_secrets_baseline.sh scan   # regenerate .secrets.baseline
scripts/detect_secrets_baseline.sh audit  # interactively review/classify detected secrets
scripts/detect_secrets_baseline.sh        # check for new secrets vs baseline (run by pre-commit)
```

Per-repo file exclusions go in `.detect-secrets-ignore` (one regex per line). Global exclusions (`.git`, `venv`, `dist`, etc.) are baked into the script.

## Architecture

### Package layout

Source lives under `src/pds/<package_name>/` using a [PEP 420 namespace package](https://peps.python.org/pep-0420/) — `src/pds/__init__.py` is intentionally minimal (no `__path__` manipulation) to support the `pds.*` namespace shared across multiple PDS Python packages.

Version is read at import time from `src/pds/<package_name>/VERSION.txt` via `importlib.resources`, not hardcoded.

Entry points (CLI scripts) are declared in `setup.cfg` under `[options.entry_points] console_scripts`.

### Tests

Tests go in `tests/pds/<package_name>/` mirroring the source tree. The `[tool:pytest]` section in `setup.cfg` configures coverage to report on the `pds` namespace.

### CI/CD

Two standard GitHub Actions workflows drive releases via [NASA-PDS/roundup-action](https://github.com/NASA-PDS/roundup-action):

- **`unstable-cicd.yaml`** — triggers on push to `main`; publishes a SNAPSHOT release to Test PyPI
- **`stable-cicd.yaml`** — triggers on push to `release/<version>` branches; publishes stable releases to PyPI

Required repository secrets: `ADMIN_GITHUB_TOKEN`, `TEST_PYPI_USERNAME`, `TEST_PYPI_PASSWORD`, `SONAR_TOKEN`.

### Code style

- **flake8** enforces PEP8 + docstrings (Google convention) + bugbear; max line length 120
- **mypy** enforces type annotations across `src/`
- **black** is configured (`pyproject.toml`) but disabled in pre-commit due to conflict with `reorder-python-imports`
- Pre-commit hooks run mypy + flake8 on commit; pytest runs on push

### Logging

Use `logging.getLogger(__name__)` — never `print()` for runtime output.
