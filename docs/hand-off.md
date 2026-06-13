# Handoff Notes

This file records the current desktop state and the things another agent should check first.

## Live State

- Desktop: Hyprland
- Wallpaper daemon: Hyprpaper
- Status bar: Waybar
- Launcher: Wofi
- Notifications: Mako
- Terminal: Kitty
- Screenshot tools: Grim, Slurp, wl-clipboard

## Managed Files

- [dot_config/hypr/hyprland.conf](/home/jonathan/rice/dot_config/hypr/hyprland.conf)
- [dot_config/hypr/hyprpaper.conf](/home/jonathan/rice/dot_config/hypr/hyprpaper.conf)
- [dot_config/waybar/config](/home/jonathan/rice/dot_config/waybar/config)
- [dot_config/waybar/style.css](/home/jonathan/rice/dot_config/waybar/style.css)

## Current Waybar Shape

- Left: `hyprland/workspaces` and `hyprland/window`
- Center: `clock`
- Right: `pulseaudio`, `network`, `tray`
- CPU and memory were removed to keep the bar quiet
- The window title collapses when empty
- The audio slot is text-only so it does not depend on glyph icons

## Current Hyprland Notes

- `exec-once` starts `hyprpaper`, `waybar`, and `mako`
- Workspaces `1` through `10` are marked `persistent:true`
- The existing keybinding convention uses `ALT` as `$mainMod`

## Things To Check First

1. If the bar disappears, check for Waybar CSS errors before touching Hyprland.
2. If empty blocks appear, inspect module-specific styling before adding more modules.
3. If a module needs icons, verify the font is actually available on the machine.
4. If a command behaves differently from the shell, launch it through Hyprland and the live session
   env, not from a bare terminal.

## Known Constraints

- The repo is public.
- Do not commit secrets, caches, auth state, or private machine data.
- Keep changes reversible and small.
- Prefer the existing Hockney palette and flat geometry over new visual directions.

## Good Next Tasks

- `mako` styling
- `wofi` styling
- screenshot workflow
- lock/suspend/session shortcuts
