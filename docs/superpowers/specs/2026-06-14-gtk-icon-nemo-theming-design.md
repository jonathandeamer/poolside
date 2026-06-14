# GTK / icon-theme / nemo theming + fastfetch logo

Date: 2026-06-14
Status: approved (pending spec review)

## Goal

Close the toolkit-layer "still default" gaps in the rice and make nemo
screenshot-ready for /r/unixporn. Everything reversible and chezmoi-tracked.

Covers audit items:

1. GTK icon theme (currently stock Adwaita blue folders).
2. GTK4 / file-chooser chrome (currently cursor-only, fully default Adwaita).
3. GTK widget theme name + UI font (currently unset; default theme + default font).
5. fastfetch logo (stock Arch glyph; colors themed but not pinned to palette).

Plus: nemo tuned for a clean showcase screenshot.

Out of scope: Qt theming (qt5ct/Kvantum) — no Qt apps in use. libadwaita
theming — `libadwaita` is not installed and no libadwaita app is in use.

## Palette anchors

Poolside palette (from CLAUDE.md): terracotta `#c96244`/`#d46a4e`, pool blues
`#3d7590`/`#5a9ec2`/`#2d808a`, greens `#5a8f66`/`#76a881`, ochre
`#cf9a24`/`#f6cb4f`, plum `#8f5d88`, cream `#fcfaf6`/`#e3ded6`, ink `#23313a`.

## 1. Icon theme — Papirus with teal folders

- Install `papirus-icon-theme` from the official `extra` repo
  (`sudo pacman -S papirus-icon-theme`). No AUR needed.
- Papirus base folders are blue. To get **teal/cyan** folders (the user's pick)
  without the AUR `papirus-folders` script and without root-owned edits, ship a
  thin repo-tracked icon theme:
  - Path: `dot_local/share/icons/Papirus-Poolside/`
  - `index.theme`: `Inherits=Papirus-Dark,Papirus,Adwaita,hicolor`
  - Override only the `places` folder icons: provide symlinks (or a small
    generator) mapping `folder*` → Papirus's shipped `folder-teal*` icons across
    the sizes Papirus uses (16,22,24,32,48,64 + `symbolic`).
- Rationale: inheriting Papirus means we ride Papirus updates for every
  non-folder icon and only carry the folder recolor ourselves. Reversible by
  deleting the theme dir and pointing `gtk-icon-theme-name` back.
- Exact `folder-teal*` source paths to be confirmed immediately after install
  (`pacman -Ql papirus-icon-theme | grep folder-teal`), since the file db is
  not synced locally at design time.

## 2 & 3. GTK settings + GTK4 chrome

`dot_config/gtk-3.0/settings.ini` and `dot_config/gtk-4.0/settings.ini` — keep
existing cursor lines, add:

```
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus-Poolside
gtk-font-name=Inter 11
gtk-application-prefer-dark-theme=false
```

(`Adwaita` is built into GTK; our `gtk.css` overrides its chrome regardless.)

GTK4: create `dot_config/gtk-4.0/gtk.css` porting the existing
`gtk-3.0/gtk.css` poolside chrome, adjusting GTK4-only selector differences
(e.g. `headerbar`/`window` handling, no `treeview` rubberband quirks). Purpose:
the GTK4 file-chooser portal and any future non-libadwaita GTK4 app match the
rest of the rice. This is future-proofing — no GTK4 app is in daily use today.

## 4. nemo — minimal chrome, still identifiably a file manager

nemo is GTK3, so it inherits `gtk-3.0/gtk.css`. Two layers:

**CSS (in `gtk-3.0/gtk.css`):** add nemo-scoped selectors so it reads as a
designed card, not stock Adwaita: `.nemo-window` background, toolbar/pathbar on
the cream panel gradient, places sidebar on the panel-deep gradient with
terracotta→plum selected rows (already partly covered by generic `.sidebar`
rules — make sure nemo's classes are included), and icon/list view selection in
pool blue. Keep contrast high and flat (no heavy gradients) per the Hockney
rules.

**Behaviour (dconf, via a tracked script):** the user approved mutating live
dconf. Ship `dot_local/bin/executable_nemo-poolside-settings`, idempotent and
re-runnable, that applies a **minimal but identifiable** file-manager layout:

- `org.nemo.preferences show-location-entry false` (breadcrumb path, not a
  raw entry) — keep the path bar (identifiable).
- `org.nemo.window-state start-with-menu-bar false` — drop the menubar.
- `org.nemo.window-state start-with-sidebar true` +
  `sidebar-bookmark-breakpoint` left default — keep the places sidebar
  (identifiable).
- `org.nemo.window-state start-with-status-bar false` — drop the status bar for
  a cleaner frame.
- `org.nemo.preferences default-folder-viewer 'icon-view'` and a sensible
  default zoom (`'standard'` or `'large'`) + thumbnail size so icons read in a
  screenshot.
- `org.nemo.preferences show-hidden-files false`.
- Cross-set the desktop interface keys so nemo picks up the rice:
  `org.gnome.desktop.interface` `icon-theme 'Papirus-Poolside'`,
  `gtk-theme 'Adwaita'`, `font-name 'Inter 11'`,
  `cursor-theme 'capitaine-cursors-light'`.

The script prints what it changes and is safe to run repeatedly. Document at the
top that it mutates dconf (live desktop state), not just repo files. Reversal:
`dconf reset -f /org/nemo/` plus resetting the interface keys (noted in the
script header).

## 5. fastfetch logo — Arch glyph pinned to palette

Keep the Arch logo (still "Arch-identifiable") but ensure it renders on-palette
rather than default Arch blue/cyan. `dot_config/fastfetch/config.jsonc` already
sets `logo.color` 1–4 to terracotta/blue/ochre/plum; verify the built-in Arch
glyph actually references all four color slots and adjust the mapping if it
falls back to defaults (may need explicit `logo.type`/`logo.source` "arch" with
the palette, or a small recolored ASCII variant if the builtin ignores slots).

## Verification

- Confirm `folder-teal*` paths and that `Papirus-Poolside` resolves
  (`gtk-launch`/`gsettings` round-trip; spot-check an icon).
- `chezmoi diff` then clean apply; nothing unexpected.
- Launch nemo: minimal chrome, teal folders, poolside selection colors, path
  bar + sidebar present.
- Run `fastfetch`: logo reads on-palette.
- `scripts/secret-scan.sh` before commit.
- Conventional commits per `docs/commits.md` (e.g. `feat(rice)` / `feat(chezmoi)`
  scopes), no AI attribution trailers.

## Reversibility summary

- Icons: delete `Papirus-Poolside` theme dir, revert `gtk-icon-theme-name`,
  optionally `pacman -R papirus-icon-theme`.
- GTK settings/css: git revert the `settings.ini` / `gtk.css` changes.
- nemo: `dconf reset -f /org/nemo/` + reset interface keys.
- fastfetch: git revert config.jsonc.
