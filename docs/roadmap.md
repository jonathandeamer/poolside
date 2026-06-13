# Rice Roadmap

This is the working roadmap for the Hockney rice. It is meant for a future agent or a future
session to pick up without re-deriving the current state.

## Current State

- Hyprland is the compositor.
- Hyprpaper is active and uses the configured Hockney pool-house wallpaper.
- Waybar is installed, running, and styled in a warm pool-house direction.
- The current Waybar layout is: workspaces, focused window title, clock, audio, network, tray.
- Hyprland workspaces `1` through `10` are persistent.
- Kitty is configured with a legible light-theme Hockney palette, 12px window padding, and 1.0 opacity.
- The repo is managed through chezmoi and should stay public-safe.

## Immediate Next Work

1. `mako`
   - Match notification styling to the bar and wallpaper palette.
   - Keep notifications readable, restrained, and not too tall.
   - Decide whether to add an urgent state color that matches the existing red-orange accent.

2. `wofi`
   - Tune launcher styling to match the same flat, sunlit palette.
   - Keep it sparse and functional, not decorative.
   - Decide whether to add a small action launcher for power/session commands.

3. Screenshot flow
   - Add or refine a screenshot binding with `grim`, `slurp`, and `wl-clipboard`.
   - Make the save path and clipboard behavior explicit.
   - Prefer a small helper script if the flow needs more than one command.

4. Kitty [Completed]
   - Finished terminal colors, padding, and opacity.
   - Kept the terminal legible in the same palette as the rest of the desktop.

5. Session polish
   - Add lock/suspend/logout handling if it does not already exist.
   - Check whether a lock screen is needed before adding more session shortcuts.

## Secondary Work

- Add a focused-window title rewrite list if the title is too noisy.
- Revisit Waybar spacing or module order if the bar still feels crowded.
- Add temperature or battery only if the hardware makes them relevant.
- Add keyboard-layout or submap status only if you start using those features.

## Design Rules

- Keep the desktop bright, calm, and rectangular.
- Prefer hard boundaries and flat color planes over gradients and blur.
- Use water, lawn, or motion only as a small accent, not as the whole theme.
- Do not drift into dark neon, vaporwave, or generic beach styling.
- Keep user-facing controls useful first, decorative second.

## Safety Rules

- Treat `/home/jonathan/rice` as the source of truth for dotfiles.
- Use chezmoi for intended changes to managed configs.
- Keep public repo safety in mind before commits and pushes.
- Run `scripts/secret-scan.sh` before any public push or large import.
- Avoid destructive desktop actions unless the user explicitly asks for them.

## Verification Loop

1. Apply config with `chezmoi apply`.
2. Check the live desktop state with `hyprctl` where needed.
3. Restart only the relevant daemon or reload Hyprland if the change needs it.
4. Inspect the bar, launcher, or notification state visually.
5. Commit only after the change is working on the live session.

## Handoff Principle

If a future agent picks this up, start from the current configs and only change one surface at a
time. This rice is supposed to stay legible and reversible.
