## Detect Secrets

### Intro

The Planetary Data System's Engineering Node uses [detect-secrets](https://github.com/Yelp/detect-secrets) to help prevent committing sensitive information—passwords, API keys, tokens, hostnames, email addresses, and high-entropy strings—to a repository. Unlike a simple pattern matcher, it uses entropy analysis to surface randomized strings that may be credentials.

Detect Secrets is already integrated into the [Python template repository](https://github.com/NASA-PDS/template-repo-python/) and the [Java template repository](https://github.com/NASA-PDS/template-repo-java/), so creating new repositories from those templates gives you the support for Detect Secrets out of the box.

**However**, you must manually install the `detect-secrets` command-line tool and make it available on your shell's `PATH` in order to support pre-commit hooks and to create or update the `.secrets.baseline` file for your repository.

### Installation

The tool is written in Python, so you'll also need Python. We recommend a dedicated virtual environment:

```bash
python3 -m venv ~/Tools/detect-secrets
~/Tools/detect-secrets/bin/pip install detect-secrets~=1.5.0
```

Then add `~/Tools/detect-secrets/bin` to your `PATH`.

### How it works in PDS repos

Each PDS Python repository ships two files that together drive secrets scanning:

| File | Purpose |
|---|---|
| `scripts/detect_secrets_baseline.sh` | Single source of truth for scan arguments and check logic. Run it directly or via pre-commit. |
| `.detect-secrets-ignore` | Per-repo file exclusions (one regex per line, `#` for comments). Supplements the global exclusions baked into the script. |

The pre-commit hook runs `scripts/detect_secrets_baseline.sh` (no arguments) on every commit. The GitHub Actions workflow `secrets-detection.yaml` runs the same script on every push and pull request to `main`.

### Create or Update the Secrets Baseline

Each repo must have a `.secrets.baseline` file at the root. This catalog tells detect-secrets which findings are known false positives (example API keys, email addresses we intentionally include, etc.).

**Scan and generate a new baseline:**

```bash
scripts/detect_secrets_baseline.sh scan
```

**Review and classify each finding** (mark each as `is_secret: true` or `is_secret: false`):

```bash
scripts/detect_secrets_baseline.sh audit
```

**Commit the baseline:**

```bash
git add .secrets.baseline
```

### Excluding files

To exclude additional files from scanning in a specific repo, add regex patterns to `.detect-secrets-ignore`, one per line:

```
# Example: ignore test fixture directories
.*/tests/data/.*

# Example: ignore generated documentation
docs/build/.*
```

Global exclusions (`.git`, `venv`, `dist`, `build`, `*.egg-info`, etc.) are already handled by the script and do not need to be repeated here.

### Check for new secrets manually

```bash
scripts/detect_secrets_baseline.sh
```

This is the same check the pre-commit hook runs. It will:
1. Fail if any entries in `.secrets.baseline` have not been audited (no `is_secret` field).
2. Fail if any new secrets are detected that are not already in the baseline.

### Configuring pre-commit hooks

After generating and committing your baseline, install the pre-commit hooks:

```bash
pre-commit install
pre-commit install -t pre-push
pre-commit install -t prepare-commit-msg
pre-commit install -t commit-msg
```

From that point on, the detect-secrets check runs automatically on every `git commit`.
