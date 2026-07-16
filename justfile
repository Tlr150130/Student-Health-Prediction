# List available recipes
default:
    @just --list

# Install/sync dependencies from the lockfile
sync:
    uv sync

# Lint with ruff
lint:
    uv run ruff check .

# Format with ruff
format:
    uv run ruff format .

# Run the test suite
test:
    uv run pytest

# Run all pre-commit hooks against every file
precommit:
    uv run pre-commit run --all-files

# Type-check with mypy
typecheck:
    uv run mypy src

# Run everything CI runs: pre-commit hooks (lint + format), mypy, and pytest
check: precommit typecheck test
