#!/usr/bin/env sh
set -eu

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$repo_root"

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --source . --no-git --redact
fi

patterns='BEGIN (RSA|OPENSSH|EC|DSA)? ?PRIVATE KEY|PRIVATE KEY|ghp_[A-Za-z0-9_]+|github_pat_[A-Za-z0-9_]+|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]+|password[[:space:]]*=|passwd[[:space:]]*=|token[[:space:]]*=|secret[[:space:]]*=|api[_-]?key[[:space:]]*=|age-secret-key-'

if rg -n --hidden --glob '!.git/**' --glob '!assets/**' --glob '!*.age' --glob '!scripts/secret-scan.sh' "$patterns" .; then
  cat >&2 <<'EOF'
Potential secret-like content found.

Review the matches above. If a match is safe, adjust scripts/secret-scan.sh with a narrow ignore.
EOF
  exit 1
fi

printf '%s\n' 'Secret scan passed.'
