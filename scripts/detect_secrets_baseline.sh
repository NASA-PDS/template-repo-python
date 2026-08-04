#!/bin/bash
#
# detect_secrets_baseline.sh — manage the detect-secrets baseline for this repo.
#
# Usage:
#   scripts/detect_secrets_baseline.sh          # CI mode: verify nothing new or unresolved
#   scripts/detect_secrets_baseline.sh scan     # Regenerate .secrets.baseline from scratch
#   scripts/detect_secrets_baseline.sh audit    # Interactively classify each finding
#
# Per-repo path exclusions go in .detect-secrets-ignore (one regex per line; # comments ok).

set -euo pipefail

BASELINE=".secrets.baseline"
BASELINE_IGNORE=".detect-secrets-ignore"

# ---------------------------------------------------------------------------
# Locate detect-secrets binary (prefer local venv over system install)
# ---------------------------------------------------------------------------

find_detect_secrets() {
    if [[ -f "venv/bin/detect-secrets" ]]; then
        echo "venv/bin/detect-secrets"
    elif [[ -f ".venv/bin/detect-secrets" ]]; then
        echo ".venv/bin/detect-secrets"
    else
        echo "detect-secrets"
    fi
}

DETECT_SECRETS="$(find_detect_secrets)"

# ---------------------------------------------------------------------------
# Build --exclude-files arguments from global + per-repo patterns
# ---------------------------------------------------------------------------

# Paths that are always excluded, regardless of repo type.
GLOBAL_EXCLUDES=(
    '\.secrets\..*'             # the baseline files themselves
    '(^|/)\.git/'               # git internals (path-segment anchored to avoid blocking .github/)
    '\.pre-commit-config\.yaml' # pre-commit config (often contains hook refs)
    'node_modules'              # JS dependencies
    'dist'                      # build output
    'build'                     # build output
    '\.venv'                    # Python virtual envs
    'venv'
    'scripts/detect_secrets_baseline\.sh'  # this script
)

build_exclude_args() {
    local args=()

    for pattern in "${GLOBAL_EXCLUDES[@]}"; do
        args+=(--exclude-files "$pattern")
    done

    # Per-repo additions from .detect-secrets-ignore
    if [[ -f "$BASELINE_IGNORE" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            [[ "$line" =~ ^[[:space:]]*#  ]] && continue  # skip comments
            [[ -z "${line// }"            ]] && continue  # skip blank lines
            args+=(--exclude-files "$line")
        done < "$BASELINE_IGNORE"
    fi

    echo "${args[@]}"
}

# Store as an array so it expands correctly when passed to detect-secrets.
read -ra EXCLUDE_ARGS <<< "$(build_exclude_args)"

# ---------------------------------------------------------------------------
# Helper: extract a sorted "file,hash" list from a baseline JSON file.
# Used to compare two baselines without caring about key ordering.
# ---------------------------------------------------------------------------

baseline_fingerprints() {
    local file="$1"
    python3 - "$file" <<'PYTHON'
import json, sys

with open(sys.argv[1]) as fh:
    data = json.load(fh)

fingerprints = [
    f"{filename},{secret['hashed_secret']}"
    for filename, secrets in data.get("results", {}).items()
    for secret in secrets
]

print("\n".join(sorted(fingerprints)))
PYTHON
}

baselines_match() {
    local a="$1" b="$2"
    diff <(baseline_fingerprints "$a") <(baseline_fingerprints "$b") > /dev/null
}

# ---------------------------------------------------------------------------
# Helper: count findings in a baseline that match a given Python condition.
# $1 = baseline file, $2 = Python expression that evaluates to True/False
#      per secret dict (variable name: `s`)
# ---------------------------------------------------------------------------

count_findings() {
    local file="$1"
    local condition="$2"
    python3 - "$file" "$condition" <<'PYTHON'
import json, sys

with open(sys.argv[1]) as fh:
    data = json.load(fh)

condition = sys.argv[2]
count = sum(
    1
    for secrets in data.get("results", {}).values()
    for s in secrets
    if eval(condition)
)

print(count)
PYTHON
}

# ---------------------------------------------------------------------------
# CI checks (default mode — no argument)
# ---------------------------------------------------------------------------

check_unaudited_findings() {
    local count
    count="$(count_findings "$BASELINE" '"is_secret" not in s')"

    if [[ "$count" -gt 0 ]]; then
        echo "⚠️  $count finding(s) in $BASELINE have not been audited yet." >&2
        echo "   Run: scripts/detect_secrets_baseline.sh audit" >&2
        return 1
    fi
}

check_confirmed_secrets() {
    local count
    count="$(count_findings "$BASELINE" 's.get("is_secret") is True')"

    if [[ "$count" -gt 0 ]]; then
        echo "⚠️  $count confirmed secret(s) are still present in $BASELINE." >&2
        echo "   Remove them from the codebase, then re-run: scripts/detect_secrets_baseline.sh scan" >&2
        return 1
    fi
}

check_new_secrets() {
    local scratch="$BASELINE.new"
    cp "$BASELINE" "$scratch"
    # shellcheck disable=SC2064
    trap "rm -f '$scratch'" RETURN

    "$DETECT_SECRETS" scan "${EXCLUDE_ARGS[@]}" --baseline "$scratch" > /dev/null

    if ! baselines_match "$BASELINE" "$scratch"; then
        cat >&2 <<EOF

⚠️  New secrets detected that are not in $BASELINE.

To investigate and resolve on your local machine:

  1. Install detect-secrets:
       pip install detect-secrets

  2. Scan and review findings:
       scripts/detect_secrets_baseline.sh scan
       scripts/detect_secrets_baseline.sh audit

  3. Commit the updated $BASELINE and re-push.

Reference: https://nasa-ammos.github.io/slim/continuous-testing/starter-kits/#detect-secrets

EOF
        return 1
    fi
}

run_ci_checks() {
    check_unaudited_findings
    check_confirmed_secrets
    check_new_secrets
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

case "${1:-}" in
    scan)
        "$DETECT_SECRETS" scan "${EXCLUDE_ARGS[@]}" > "$BASELINE"
        echo "✅ $BASELINE updated."
        echo "   Next: scripts/detect_secrets_baseline.sh audit"
        ;;
    audit)
        "$DETECT_SECRETS" audit "$BASELINE"
        ;;
    "")
        run_ci_checks
        echo "✅ No new secrets detected."
        ;;
    *)
        echo "Usage: $0 [scan|audit]" >&2
        exit 1
        ;;
esac
