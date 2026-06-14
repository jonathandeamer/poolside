# Hockney-gallery nemo + two-scene showcase

Date: 2026-06-14
Status: approved (pending spec review)

## Goal

Turn nemo into an ultra-minimal Hockney "gallery wall" and split the desktop
showcase into two lighter scenes on two workspaces, so no single screenshot
buries the wallpaper. Populate the gallery from a local `~/paintings/` folder
of David Hockney works scraped from hockney.com.

Builds on the GTK/icon/nemo theming already on this branch.

## Decisions (from brainstorming)

- Everyday nemo goes ultra-minimal **globally** (no menubar/statusbar/sidebar;
  slim toolbar + breadcrumb kept so it stays navigable). Icon view, large zoom,
  **filename labels on**.
- Showcase splits into two scenes on two workspaces:
  - **Scene A "system"** — workspace 2 — `fastfetch` (top-left) + `cava`
    (bottom). Weather pane dropped (script stays usable standalone).
  - **Scene B "gallery"** — workspace 3 — nemo at `~/paintings`, **900×600
    centered** (`move 510 240` on 1920×1080) so wallpaper frames it.
- `rice-showcase shot` captures **two** files, one per scene.
- `~/paintings/` is **local-only** — copyrighted reproductions, personal/local
  use, never committed (same posture as the gitignored `assets/hockney/`).

## Component 1 — painting downloader

`dot_local/bin/executable_fetch-hockney-paintings`

- Source: `https://www.hockney.com/works/paintings/<decade>` index pages. The
  gallery images use direct URLs of the form
  `https://www.hockney.com/img/gallery/paintings/<decade>/<code>.jpg`.
- Behaviour:
  - Iterate the decade slugs linked from the paintings landing page
    (50s,60s,70s,80s,90s,2000s,2010s + the "82 Portraits" set); exact slugs
    confirmed at implementation time by fetching the landing page.
  - For each decade page, extract unique `img/gallery/paintings/...jpg` URLs.
  - Download to `~/paintings/<decade>-<code>.jpg`, **skipping files that already
    exist** (idempotent).
  - Be polite: real `User-Agent`, `curl --limit-rate`, `--max-time` per file,
    a short `sleep` between requests, continue past individual failures.
  - Print a summary (downloaded / skipped / failed counts).
- Header documents: local-only, personal use, re-runnable, reversal is
  `rm -rf ~/paintings`.

## Component 2 — nemo ultra-minimal (global)

Revise the existing `dot_local/bin/executable_nemo-poolside-settings` (already
on this branch) to go further:

- Keep: `start-with-menu-bar false`, `start-with-status-bar false`,
  `show-location-entry false` (breadcrumb), icon-view + `default-zoom-level
  'large'`, hidden files off, thumbnails always, the interface theme keys.
- Add: `org.nemo.window-state start-with-sidebar false` (hide the places
  sidebar — the "even more minimal" step).
- Labels: nemo icon view shows filenames by default; no change needed (this is
  the "grid with labels" look).

This is now the everyday nemo state, so the gallery scene needs no per-window
toggling.

## Component 3 — two-scene showcase

Rewrite `dot_local/bin/executable_rice-showcase` around two scenes:

- Constants: `SYSTEM_WS=${RICE_SHOWCASE_WS:-2}`, `GALLERY_WS=3`,
  `GALLERY_DIR=$HOME/paintings`.
- Panes: Scene A launches `rice_fetch` (fastfetch) and `rice_cava` (cava, or the
  existing eza placeholder). Scene B launches `nemo "$GALLERY_DIR"`.
- `summon`: record current workspace, launch all panes; Hyprland windowrules
  pin each pane to its workspace (so async launch order doesn't matter).
- `dismiss`: close every `rice_*` window (existing logic) **and** the gallery
  nemo window (match the nemo client whose title is `paintings`, close by
  address), then return to the recorded workspace.
- `shot [base]`: ensure both scenes are up; then
  1. switch to `SYSTEM_WS`, start `cava-tone`, wait for `pw-play`, grab →
     `…-system.png`;
  2. switch to `GALLERY_WS`, wait a beat for nemo thumbnails to render, grab →
     `…-gallery.png`.
  Default base: `~/rice/screenshots/showcase-$(date +%Y%m%d-%H%M%S)`; the two
  suffixes are appended. Print both saved paths.
- `scene_is_up` treats the scene as present if either `rice_*` windows or the
  gallery nemo exist.

## Component 4 — Hyprland window rules

In `dot_config/hypr/hyprland.conf`:

- **Remove** the two `rice_weather` rules (size/move). Leave the shared
  `rice_.*` rules and the `rice_fetch`/`rice_cava` geometry untouched.
- **Add** a gallery rule set, matched on class `nemo` AND title `paintings`:
  ```
  windowrule = workspace 3, match:class ^(nemo)$ title:^(paintings)$
  windowrule = float 1,     match:class ^(nemo)$ title:^(paintings)$
  windowrule = size 900 600, match:class ^(nemo)$ title:^(paintings)$
  windowrule = move 510 240, match:class ^(nemo)$ title:^(paintings)$
  windowrule = rounding 10,  match:class ^(nemo)$ title:^(paintings)$
  windowrule = opacity 1.0 override 1.0 override, match:class ^(nemo)$ title:^(paintings)$
  ```
  (Exact windowrule syntax verified against the existing rules in the file at
  implementation time — match the established `match:class ^(...)$` style.)
- **Caveat (documented in the conf):** because nemo cannot take a custom
  `--class` under Wayland, the rule keys on the window title. Manually opening
  `~/paintings` in nemo will therefore also dock it to workspace 3 at this
  geometry. Acceptable for a rice; rename the folder or remove the rule to opt
  out.

## Verification

- Run `fetch-hockney-paintings`; confirm `~/paintings/` fills with `*.jpg` and a
  re-run skips everything.
- Apply the nemo settings; confirm sidebar is gone (`gsettings get
  org.nemo.window-state start-with-sidebar` → `false`).
- `rice-showcase up`; confirm Scene A on ws2 (fetch+cava, open top-right) and
  Scene B on ws3 (centered gallery, wallpaper framing, thumbnails rendered).
- `rice-showcase shot`; confirm two PNGs saved (`-system`, `-gallery`).
- `rice-showcase down`; confirm all panes incl. the gallery nemo close and the
  original workspace is restored.
- `chezmoi diff` clean for managed files; `scripts/secret-scan.sh` passes;
  conventional commits per `docs/commits.md`.

## Reversibility

- `rm -rf ~/paintings` removes the downloads.
- nemo: `dconf reset -f /org/nemo/` (script header already documents this).
- showcase/hypr/downloader: git revert the commits.
- `~/paintings/` is never committed, so nothing leaks to the public repo.
