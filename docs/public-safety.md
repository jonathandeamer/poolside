# Public Repo Safety

This repo is intended to be safe to publish. Treat every committed file as public.

## Never commit

- SSH private keys, age identities, GPG private keys, or WireGuard private keys
- API tokens, access tokens, session cookies, recovery codes, or app passwords
- Shell history
- Browser or app auth caches
- Password stores unless encrypted intentionally
- Private host inventories, private IP mappings, or sensitive account identifiers unless explicitly
  intended for publication

## Inspect before adding

- `~/.ssh/config`: can expose hostnames, users, private IPs, and identity paths.
- `~/.gitconfig`: can expose private email, signing keys, and work-specific settings.
- App configs: can contain account IDs, tokens, recent files, and absolute paths.
- Generated config directories: often mix useful config with cache and auth state.

## Use templates and encryption

For machine-specific values, use chezmoi templates and local data rather than committed literals:

```text
dot_gitconfig.tmpl
dot_ssh/config.tmpl
```

For secrets that must be managed by chezmoi, use supported encryption such as age or GPG. Encrypted
files can be public; the private identity must stay off-repo.

## Safety checks

Before public pushes:

```sh
git status
chezmoi managed
chezmoi diff
scripts/secret-scan.sh
```

If `gitleaks` is installed, `scripts/secret-scan.sh` will run it. The script also includes a small
fallback regex scan for common private keys, tokens, and secret assignments.

## Hooks

The repo uses versioned hooks in `.githooks/`.

- `commit-msg` enforces Conventional Commit types and scopes.
- `pre-commit` runs the public-safety secret scan against the worktree.

Enable hooks in a clone with:

```sh
git config core.hooksPath .githooks
```
