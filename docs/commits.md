# Commit Convention

Use Conventional Commits:

```text
type(scope): subject
type(scope)!: subject
```

The subject should be imperative, lower-case where natural, and should not end with a period.

Examples:

```text
feat(hypr): add workspace navigation bindings
fix(waybar): correct network module styling
docs(superpowers): document screenshot workflow
chore(chezmoi): add kitty config to source state
```

## Types

- `feat`: user-visible behavior, config, or workflow capability
- `fix`: bug fix or broken config correction
- `docs`: documentation only
- `style`: visual styling that does not change behavior
- `refactor`: restructure existing config without intended behavior change
- `chore`: maintenance, repo plumbing, package lists, generated updates
- `build`: package manager, install, or system build inputs
- `ci`: automation or checks
- `test`: validation scripts or test fixtures
- `perf`: performance or startup improvement
- `revert`: revert a previous commit

## Scopes

- `arch`: OS-level Arch setup and packages
- `assets`: tracked static assets
- `audio`: PipeWire, WirePlumber, volume, and audio routing
- `chezmoi`: chezmoi source state and workflow
- `docs`: general project documentation
- `fonts`: fonts and font rendering
- `git`: git configuration, hooks, ignores, and repository workflow
- `hypr`: Hyprland compositor config
- `hyprpaper`: wallpaper daemon config
- `kitty`: terminal config
- `mako`: notifications
- `portal`: xdg desktop portal integration
- `rice`: cross-component desktop appearance
- `screenshots`: grim, slurp, wl-clipboard, and screenshot workflows
- `security`: public-safety checks, secret scanning, and encryption policy
- `shell`: shell profile, aliases, prompt, and command-line tools
- `superpowers`: superpowers documentation
- `theme`: colors, icons, cursors, GTK/Qt theme choices
- `wallpaper`: wallpaper files and selection
- `waybar`: Waybar config and styling
- `wofi`: launcher config and styling
