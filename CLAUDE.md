# CLAUDE.md

This file gives local working guidance for Claude/Codex in this repository.

## What this is

This is the local workspace for an Arch Linux ricing project. The goal is learning and iterating on
a personal Hyprland desktop: window manager config, Waybar, launcher, notifications, wallpaper,
terminal styling, screenshots, and related dotfiles.

This is not an application codebase. Prefer small, reversible config changes and explain what each
change affects.

## Environment

- Machine: local Arch Linux ARM/aarch64 system.
- Desktop: Hyprland.
- Shell/user: normal local user workflow; do not assume a remote macOS host or SSH target.
- Configs may live directly under `~/.config` and/or be managed through chezmoi.

Useful installed rice stack:

- `hyprland`
- `kitty`
- `waybar`
- `wofi`
- `mako`
- `hyprpaper`
- `grim`, `slurp`, `wl-clipboard`
- `xdg-desktop-portal-hyprland`
- `hyprpolkitagent`
- `mesa`
- `ttf-jetbrains-mono-nerd`
- PipeWire audio packages

## Operating rules

- Work locally unless the user explicitly asks for remote/SSH work.
- Be careful with session-level commands. Do not restart Hyprland, kill the compositor, reboot, or
  log the user out unless explicitly asked.
- Use btrfs snapshots before risky desktop experiments when practical. The root filesystem was set
  up as btrfs during the original install.
- `kmscon` was previously disabled because it blocked Hyprland by holding DRM master on tty1. Do not
  re-enable `kmscon` unless the user explicitly decides to revisit that setup.
- Prefer reversible edits: keep backups for larger config changes and use git/chezmoi where possible.

## Hyprland config

- Main config: `~/.config/hypr/hyprland.conf`.
- Use classic Hyprland `.conf` syntax. Do not switch to Lua config.
- Existing convention: `$mainMod` is `ALT`. Keep that unless the user asks to change keybinding
  philosophy.
- Hyprland reference: https://wiki.hypr.land/

## Dotfiles workflow

The intended source of truth is chezmoi backed by a GitHub remote.

- Prefer editing through chezmoi if the relevant file is already managed there.
- Commit and push known-good dotfiles before risky experiments.
- Remember that btrfs rollback can revert local state, but it will not revert the remote.
- Follow `docs/chezmoi-ricing.md` for what should and should not be tracked.

When changing dotfiles, first check whether the target file is managed by chezmoi, then edit the
source file rather than only editing the applied copy.

## Public repo safety

Assume everything committed here is public. Do not commit raw secrets, private keys, shell history,
auth caches, or private machine inventory. Use chezmoi templates and local data for machine-specific
values, and use age/GPG encryption for secrets that must be managed by chezmoi.

Before public pushes or large dotfile imports, run `scripts/secret-scan.sh` and inspect
`chezmoi diff`. See `docs/public-safety.md`.

## Commit workflow

Use Conventional Commits for this repo. The versioned commit hook enforces the allowed types and
scopes documented in `docs/commits.md`, including scopes for Arch setup, ricing components, chezmoi,
git workflow, public-safety work, and superpowers documentation.
