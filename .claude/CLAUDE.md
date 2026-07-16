# Student Health Prediction

## Project Overview

For each patient, predict a health label — `fit`, `unhealthy`, or `at-risk` — from demographic, lifestyle, physical activity, and health metrics. This is treated as a real clinical decision-support problem, not just a Kaggle submission: doctors act on flagged patients, batch inference, HIPAA-sensitive data. Success is measured as balanced accuracy, beating a majority-class naive baseline.

The project has two phases: (1) complete the Kaggle competition end-to-end and submit test predictions, then (2) containerize and deploy a model-serving endpoint — and maybe a UI — with Docker. See `README.md` for the detailed phase breakdown.

`README.md` is the source of truth for evolving business context (open questions, data assumptions, deployment plans) — read it before making modeling or data decisions, and don't duplicate it here.

## Working With the User

Don't just accept the user's stated approach at face value. Actively question assumptions and surface what's missing — edge cases, data quality issues, class imbalance effects, privacy/HIPAA implications, deployment or security considerations, things that don't match the business context in `README.md`. Raise these before or while implementing, not buried after the fact.

If the user says to ignore, skip, or drop a concern, proceed without re-raising it — they've made the call. This applies per-concern, not as a blanket waiver for future ones.

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
| Type checking | mypy | Static type checking |

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

### mypy

- Run via `uv run mypy src` (or `just typecheck`); wired into CI (`.github/workflows/ci.yml`) and `just check`.
- Config lives in `pyproject.toml` alongside ruff/pytest config.
- Type hint new code in `src/` so it stays clean under mypy rather than adding suppressions.

## Software Engineering Best Practices

Applies to any code added under `src/` and `tests/`, on top of the general engineering instructions already governing this session:

- Type-hint all new functions and keep them clean under mypy (see above) rather than reaching for `# type: ignore`.
- Keep transformations and model logic as small, named, testable functions — mirrored by a test in `tests/` — rather than inline notebook or script logic.
- Validate and handle errors at system boundaries only (data ingestion, external I/O, API/UI inputs once those exist); trust internal function contracts elsewhere.
- Docstrings only where the *why* isn't obvious from the name/signature — not restating what well-named code already says.
- Fix random seeds anywhere PyTorch (or other stochastic logic) is used, so training and evaluation are reproducible.
- No premature abstraction: don't build for a hypothetical future phase (e.g. the Docker/GCP deployment work) while still in the modeling phase.
- Keep changes reviewable — small, focused diffs over sprawling ones, even when working solo.

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
