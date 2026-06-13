# Chezmoi Ricing Workflow

Use chezmoi as the source of truth for intentional desktop config, not for every piece of desktop
state. Ricing produces caches, generated files, account state, logs, and machine-specific paths; keep
those out of the repo.

## Source layout

This repo is the chezmoi source directory. The expected shape is:

```text
dot_config/
  hypr/
    hyprland.conf
  waybar/
    config
    style.css
  kitty/
    kitty.conf
  wofi/
  mako/
  hyprpaper/
dot_local/
  bin/
docs/
.chezmoiignore
.gitignore
CLAUDE.md
```

For project direction and transfer notes, see:

- `docs/roadmap.md`
- `docs/hand-off.md`

## Track

- Hyprland config
- Waybar config and CSS
- Kitty config
- Wofi config and styling
- Mako config
- Hyprpaper config
- Small scripts in `~/.local/bin`
- Shell aliases/functions that support the desktop workflow
- Theme declarations written for this setup

## Be careful

- Wallpapers: track only if they are small and safe to publish; otherwise document where they come
  from or install them with a script.
- Fonts: usually document package names instead of committing font files.
- GTK/Qt themes, icons, and cursors: prefer package documentation or scripts over vendoring large
  theme trees.
- `~/.ssh/config` and `~/.gitconfig`: use templates if they contain private hostnames, identities,
  or personal email addresses.
- App configs: inspect for tokens, account IDs, recent files, and absolute local paths before adding.

## Do not track

- Caches
- State directories
- Logs
- Shell history
- Browser or app authentication state
- Generated thumbnails
- Private keys
- Raw secrets

## Daily workflow

Add a live file to the source state:

```sh
chezmoi add ~/.config/hypr/hyprland.conf
```

Edit the source state:

```sh
chezmoi edit ~/.config/hypr/hyprland.conf
```

Inspect and apply:

```sh
chezmoi diff
chezmoi apply
```

If a live file was edited directly, update the source state:

```sh
chezmoi re-add ~/.config/hypr/hyprland.conf
```

Use git through chezmoi or directly from this repo:

```sh
chezmoi git status
chezmoi git add .
chezmoi git commit -m "feat(hypr): add workspace bindings"
```

## Experiment workflow

Use branches for larger visual changes:

```sh
chezmoi git switch -c rice/new-waybar-theme
chezmoi diff
chezmoi apply
chezmoi git commit -am "style(waybar): refine workspace styling"
```

For risky desktop experiments, take a btrfs snapshot first when practical and commit known-good
dotfiles before making changes.

## Templates

Use templates for private or machine-specific values:

```text
dot_gitconfig.tmpl
dot_ssh/config.tmpl
```

Keep local-only values in chezmoi data, prompts, environment variables, or an encrypted secret
manager. Do not commit private literals to a public repo.

## First configs to add

Start with the core ricing configs:

```sh
chezmoi add ~/.config/hypr/hyprland.conf
chezmoi add ~/.config/waybar
chezmoi add ~/.config/kitty
chezmoi add ~/.config/wofi
chezmoi add ~/.config/mako
chezmoi add ~/.config/hyprpaper
```

Before committing, inspect:

```sh
chezmoi diff
git status
scripts/secret-scan.sh
```
