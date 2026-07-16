# Student Health Prediction

## Project Overview

For each patient, predict a health label — `fit`, `unhealthy`, or `at-risk` — from demographic, lifestyle, physical activity, and health metrics. This is treated as a real clinical decision-support problem, not just a Kaggle submission: doctors act on flagged patients, batch inference, HIPAA-sensitive data. Success is measured as balanced accuracy, beating a majority-class naive baseline.

`README.md` is the source of truth for evolving business context (open questions, data assumptions, deployment plans) — read it before making modeling or data decisions, and don't duplicate it here.

## Project Structure

- `src/health_classifier/` — src-layout package (name intentionally left as `health_classifier` despite the project being named `student-health-prediction`; don't "fix" this without being asked)
  - `infrastructure/` — I/O, data loading, external services (DVC/MLflow config, future GCP integration)
  - `modules/` — feature engineering, training, evaluation, explainability
  - `shared/` — shared utils, constants, types
- `tests/` — mirrors the `src/health_classifier/` structure
- `notebooks/` — EDA and exploration only; promote any logic worth reusing into `src/` modules rather than leaving it in a notebook
- `data/` — never commit files here directly to git; track via DVC (see below)

## Tech Stack

| Category | Tool | Purpose |
|---|---|---|
| Environment & deps | uv | Package/venv management, lockfile |
| Lint & format | ruff | Sole linter/formatter |
| Git hooks | pre-commit | Enforce lint/format before commit |
| Testing | pytest | Unit tests |
| Data manipulation | pandas | Loading, cleaning, feature engineering |
| Modeling | PyTorch | Model implementation |
| Experiment tracking | MLflow | Params/metrics/artifacts per run |
| Data & model versioning | DVC | Version large/binary artifacts |
| Explainability | SHAP | Required per business context |

See "Extending this document" below for how to add a new row/tool.

### uv

- Use uv exclusively — no pip, poetry, or conda.
- Runtime deps: `uv add <pkg>`. Dev-only tools: `uv add --dev <pkg>`.
- Run everything through it: `uv run pytest`, `uv run python -m health_classifier`, etc., so the project venv resolves correctly.
- Commit `uv.lock`.
- `pyproject.toml` is the single source of truth for dependencies and tool config (`[tool.ruff]`, `[tool.pytest.ini_options]`, etc.).

### ruff

- Sole linter and formatter — no flake8/black/isort.
- Config lives in `[tool.ruff]` in `pyproject.toml`.
- Run via `uv run ruff check` / `uv run ruff format`.

### pre-commit

- Hooks run `ruff check --fix` and `ruff format` only — kept intentionally fast.
- Heavier checks (full test suite, notebook execution) belong in CI, not pre-commit.
- Install once configured: `uv run pre-commit install`.

### pytest

- New logic in `src/` gets coverage in `tests/`, mirroring the module it tests.
- Run via `uv run pytest`. Config in `[tool.pytest.ini_options]`.
- Favor small, fast, deterministic unit tests using fixtures over loading the real dataset.

### pandas

- Use for all data loading, cleaning, and feature engineering.
- Keep transformations as named, testable functions in `src/health_classifier/modules/` rather than inline notebook cells.

### PyTorch

- Use for model implementation.
- Fix random seeds for reproducibility.
- Output is multiclass over the three labels (`fit` / `unhealthy` / `at-risk`).

### MLflow

- Local file store only (`./mlruns`) — no remote tracking server. View with `mlflow ui`.
- Add `mlruns/` to `.gitignore`.
- Every training run logs: params, metrics (balanced accuracy vs. baseline), and artifacts (model + SHAP plots).

### DVC

- Tracks large/binary artifacts: `data/` and trained models. Never commit these directly to git — `dvc add` them and commit the resulting `.dvc` pointer file instead.
- Remote is a local or network path (no cloud provider) — configure via `dvc remote add`.
- Once a real pipeline exists, define stages (data prep → feature engineering → train → eval) in `dvc.yaml` so `dvc repro` reproduces a run end-to-end.

### SHAP

- Required per business context ("explainability matters") — every trained model needs a companion SHAP analysis (per-class feature importance for the multiclass output) logged as an MLflow artifact before it's considered done.

## Privacy & Ethics

- Data is HIPAA-sensitive even though patients are keyed by ID — treat it accordingly.
- Never log raw patient records or include them in commit messages/PRs.
- Never commit `data/` to git — DVC only.
- Treat exported artifacts (SHAP plots, error breakdowns) as potentially sensitive unless the underlying columns are confirmed fully de-identified.

## Extending this document

When introducing a new technology to the project:

1. Add the dependency via `uv add` (or `uv add --dev`).
2. Add one row to the Tech Stack table and one short detail section following the pattern above.
3. Keep sections short — link out to the tool's own docs rather than reproducing them here.
