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
- `btop` (themed system monitor), `eza`, `bat`, `fzf`, `zoxide` (shell tooling)

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

## Theming

- The rice uses a single "A Bigger Splash" / poolside palette across configs: terracotta
  (`#c96244`/`#d46a4e`), pool blues (`#3d7590`/`#5a9ec2`/`#2d808a`), greens (`#5a8f66`/`#76a881`),
  ochre (`#cf9a24`/`#f6cb4f`), plum (`#8f5d88`), and cream (`#fcfaf6`/`#e3ded6`).
- The terminal (kitty) currently runs the **light** theme: cream `#fcfaf6` background, dark `#23313a`
  foreground. A commented-out dark option exists in the kitty config. When theming terminal apps,
  target a light/cream background (dark ink, deeper/saturated accents) — light-foreground themes
  render unreadably light-on-cream.
- `bat` uses a custom theme at `dot_config/bat/themes/Poolside.tmTheme`. Custom bat themes are
  compiled into a cache, so after editing the theme file you must run `bat cache --build` for changes
  to show.
- `btop` uses a custom theme at `dot_config/btop/themes/poolside.theme`, selected via
  `color_theme` in `dot_config/btop/btop.conf` with `theme_background = False` so it inherits the
  terminal background.

## Dotfiles workflow

The source of truth is this chezmoi source repo backed by the public GitHub remote:

- Local source: `/home/jonathan/rice`
- Remote: `https://github.com/jonathandeamer/poolside`
- Default branch: `main`

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

Do not add AI attribution metadata to commits. The hook rejects AI co-authors, AI/LLM/generated
trailers, and footers such as "Generated with ..." or "Assisted by ..." that credit AI tools.
