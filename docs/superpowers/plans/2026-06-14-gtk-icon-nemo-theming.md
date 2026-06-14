# GTK / icon-theme / nemo theming + fastfetch logo — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Theme the GTK/icon toolkit layer (Papirus teal folders, GTK3+GTK4 chrome, widget theme + Inter font) and tune nemo for a clean /r/unixporn screenshot, all reversible and chezmoi-tracked.

**Architecture:** This repo at `/home/jonathan/rice` is the chezmoi source (copy mode). Each task edits a `dot_*` source file, runs `chezmoi apply -v` to push it to `~`, then verifies live. Icons come from official `papirus-icon-theme`; teal folders via a generated child theme `Papirus-Poolside` that inherits Papirus. nemo behaviour is set in dconf by a tracked, idempotent script.

**Tech Stack:** chezmoi, GTK3/GTK4 CSS, Papirus icon theme, gsettings/dconf, fastfetch, bash.

**Note on "tests":** these are config artifacts, not code, so each task's verification is a concrete shell command with expected output (the analog of a test), plus a live eyeball where visual.

---

### Task 1: Install Papirus icon theme

**Files:** none (system package)

- [ ] **Step 1: Install from official repo**

Run:
```bash
sudo pacman -S --needed papirus-icon-theme
```
Expected: installs `papirus-icon-theme` (and `papirus-icon-theme-…` deps if any) from `extra`. Re-runnable; `--needed` no-ops if present.

- [ ] **Step 2: Confirm the theme and teal folders are present**

Run:
```bash
ls -d /usr/share/icons/Papirus && \
pacman -Ql papirus-icon-theme | grep -m3 'places/folder-teal\.svg'
```
Expected: `/usr/share/icons/Papirus` exists and at least one `.../places/folder-teal.svg` path prints. If `folder-teal.svg` is absent, list available colors with `pacman -Ql papirus-icon-theme | grep -oE 'folder-[a-z]+\.svg' | sort -u` and stop — the design's teal choice needs a real variant.

- [ ] **Step 3: Record the package in docs/packages.md**

Add a line under the icon/theming section of `docs/packages.md` noting `papirus-icon-theme` (icon set for GTK apps). Keep the file's existing format.

- [ ] **Step 4: Commit**

```bash
git add docs/packages.md
git commit -m "docs(packages): record papirus-icon-theme dependency"
```

---

### Task 2: Generate the Papirus-Poolside teal child theme

**Files:**
- Create: `dot_local/bin/executable_papirus-poolside-folders`

- [ ] **Step 1: Write the generator script**

Create `dot_local/bin/executable_papirus-poolside-folders`:

```bash
#!/usr/bin/env bash
# Build ~/.local/share/icons/Papirus-Poolside: inherits Papirus, recolors
# folder icons to the poolside teal variant. Idempotent / re-runnable.
# Reversal: rm -rf ~/.local/share/icons/Papirus-Poolside
set -euo pipefail

COLOR="teal"
SRC="/usr/share/icons/Papirus"
DEST="$HOME/.local/share/icons/Papirus-Poolside"

[ -d "$SRC" ] || { echo "Papirus not installed at $SRC" >&2; exit 1; }

# Size dirs that actually ship a folder-<color>.svg (e.g. 24x24, 64x64).
mapfile -t dirs < <(
  find "$SRC" -type f -name "folder-${COLOR}.svg" -printf '%h\n' \
    | sed -e "s#^$SRC/##" -e 's#/places$##' | sort -u
)
[ "${#dirs[@]}" -gt 0 ] || { echo "No folder-${COLOR}.svg in $SRC" >&2; exit 1; }

rm -rf "$DEST"
mkdir -p "$DEST"

# index.theme
{
  echo "[Icon Theme]"
  echo "Name=Papirus-Poolside"
  echo "Comment=Papirus with poolside teal folders"
  echo "Inherits=Papirus,Adwaita,hicolor"
  printf "Directories="
  printf "%s/places," "${dirs[@]}"; echo
  echo
  for size in "${dirs[@]}"; do
    px=${size%%x*}
    echo "[$size/places]"
    echo "Size=$px"
    echo "Type=Fixed"
    echo "Context=Places"
    echo
  done
} > "$DEST/index.theme"

# Symlink recolored folders, stripping "-teal" from each name.
for size in "${dirs[@]}"; do
  s="$SRC/$size/places"
  t="$DEST/$size/places"
  mkdir -p "$t"
  for src in "$s"/folder-${COLOR}*.svg; do
    [ -e "$src" ] || continue
    base=$(basename "$src")              # folder-teal-documents.svg
    name="folder${base#folder-${COLOR}}" # folder-documents.svg / folder.svg
    ln -sf "$src" "$t/$name"
  done
done

gtk-update-icon-cache -f "$DEST" >/dev/null 2>&1 || true
echo "Built $DEST (${#dirs[@]} size dirs, ${COLOR} folders)."
```

- [ ] **Step 2: Apply it to ~ via chezmoi**

Run:
```bash
chezmoi apply -v ~/.local/bin/papirus-poolside-folders
```
Expected: chezmoi reports creating `~/.local/bin/papirus-poolside-folders` (executable, the `executable_` prefix). No diff on re-run.

- [ ] **Step 3: Run the generator**

Run:
```bash
~/.local/bin/papirus-poolside-folders
```
Expected: prints `Built /home/jonathan/.local/share/icons/Papirus-Poolside (N size dirs, teal folders).` with N ≥ 1.

- [ ] **Step 4: Verify the child theme resolves a teal folder**

Run:
```bash
test -f ~/.local/share/icons/Papirus-Poolside/index.theme && \
ls -l ~/.local/share/icons/Papirus-Poolside/*/places/folder.svg | head -3
```
Expected: `index.theme` exists and `folder.svg` entries are symlinks pointing at `.../Papirus/<size>/places/folder-teal.svg`.

- [ ] **Step 5: Commit**

```bash
git add dot_local/bin/executable_papirus-poolside-folders
git commit -m "feat(rice): generate Papirus-Poolside teal-folder icon theme"
```

---

### Task 3: Point GTK3 at the theme, icons, and Inter font

**Files:**
- Modify: `dot_config/gtk-3.0/settings.ini`

- [ ] **Step 1: Replace settings.ini with the full set**

Overwrite `dot_config/gtk-3.0/settings.ini`:

```ini
[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus-Poolside
gtk-font-name=Inter 11
gtk-cursor-theme-name=capitaine-cursors-light
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=false
```

- [ ] **Step 2: Apply**

Run:
```bash
chezmoi apply -v ~/.config/gtk-3.0/settings.ini && cat ~/.config/gtk-3.0/settings.ini
```
Expected: applied file shows the six lines above.

- [ ] **Step 3: Commit**

```bash
git add dot_config/gtk-3.0/settings.ini
git commit -m "feat(rice): set GTK3 theme, Papirus-Poolside icons, Inter font"
```

---

### Task 4: GTK4 settings + ported chrome CSS

**Files:**
- Modify: `dot_config/gtk-4.0/settings.ini`
- Create: `dot_config/gtk-4.0/gtk.css`

- [ ] **Step 1: Replace the GTK4 settings.ini**

Overwrite `dot_config/gtk-4.0/settings.ini`:

```ini
[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus-Poolside
gtk-font-name=Inter 11
gtk-cursor-theme-name=capitaine-cursors-light
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=false
```

- [ ] **Step 2: Create gtk-4.0/gtk.css by copying the GTK3 chrome**

Run:
```bash
cp dot_config/gtk-3.0/gtk.css dot_config/gtk-4.0/gtk.css
```
This reuses the exact poolside palette + chrome already authored for GTK3.

- [ ] **Step 3: Append GTK4 view selectors to gtk-4.0/gtk.css**

GTK4 file-chooser/portal use `gridview`/`listview`/`columnview` instead of `iconview`/`treeview`. Append this block to the end of `dot_config/gtk-4.0/gtk.css`:

```css
/* ---- GTK4-specific view widgets (file chooser portal) ---- */
gridview child,
listview row,
columnview row {
    background-color: @poolside_bg;
    color: @poolside_fg;
    border-radius: 4px;
}

gridview child:selected,
listview row:selected,
columnview row:selected {
    background-color: @poolside_blue;
    color: @poolside_bg;
}

gridview child:hover,
listview row:hover,
columnview row:hover {
    background-color: alpha(@poolside_yellow, 0.20);
}

/* GTK4 split headerbars in the file chooser */
windowhandle > headerbar {
    background-image: linear-gradient(to bottom, #fffdf9, @poolside_panel);
}
```

- [ ] **Step 4: Apply both files**

Run:
```bash
chezmoi apply -v ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/gtk.css && \
ls -l ~/.config/gtk-4.0/gtk.css
```
Expected: both applied; `gtk.css` exists in `~/.config/gtk-4.0/`.

- [ ] **Step 5: Verify CSS parses (no GTK warnings)**

Run:
```bash
GTK_DEBUG=interactive timeout 2 gtk4-demo 2>&1 | grep -i 'gtk.css' || echo "no gtk.css parse errors"
```
Expected: `no gtk.css parse errors` (if `gtk4-demo` is unavailable, skip — the file mirrors valid GTK3 syntax; verify visually via the file chooser in Task 7).

- [ ] **Step 6: Commit**

```bash
git add dot_config/gtk-4.0/settings.ini dot_config/gtk-4.0/gtk.css
git commit -m "feat(rice): add GTK4 settings and poolside chrome CSS"
```

---

### Task 5: nemo chrome — minimal, still a file manager

**Files:**
- Modify: `dot_config/gtk-3.0/gtk.css` (append nemo block)

- [ ] **Step 1: Append a nemo-scoped block to gtk-3.0/gtk.css**

nemo is GTK3 and already inherits the generic `.sidebar`/`headerbar`/`toolbar`/`treeview` rules. Append this to pin nemo's own containers to the cream palette and keep its info bars on-theme:

```css
/* ---- nemo: keep its own chrome on the poolside palette ---- */
.nemo-window,
.nemo-window .view,
.nemo-window notebook,
.nemo-window stack {
    background-color: @poolside_bg;
    color: @poolside_fg;
}

/* navigation / location toolbar */
.nemo-window .primary-toolbar,
.nemo-window toolbar {
    background-image: linear-gradient(to bottom, #fffdf9, @poolside_panel);
    border-bottom: 1px solid alpha(@poolside_terracotta, 0.28);
}

/* the "cluebar" info strip nemo shows for trash/locations */
.nemo-cluebar,
.nemo-cluebar label {
    background-color: alpha(@poolside_yellow, 0.22);
    color: @poolside_fg;
}

/* places sidebar (nemo uses its own class alongside .sidebar) */
.nemo-places-sidebar,
.nemo-places-sidebar.view {
    background-image: linear-gradient(to bottom, @poolside_panel, @poolside_panel_deep);
}

/* selected file row/icon → pool blue, matching the rest of the rice */
.nemo-window .view:selected,
.nemo-window iconview:selected,
.nemo-window treeview:selected {
    background-color: @poolside_blue;
    color: @poolside_bg;
}
```

- [ ] **Step 2: Apply**

Run:
```bash
chezmoi apply -v ~/.config/gtk-3.0/gtk.css && tail -n 30 ~/.config/gtk-3.0/gtk.css
```
Expected: the nemo block is present at the end of the applied file.

- [ ] **Step 3: Commit**

```bash
git add dot_config/gtk-3.0/gtk.css
git commit -m "style(rice): theme nemo chrome on the poolside palette"
```

---

### Task 6: nemo dconf — minimal layout, still identifiable

**Files:**
- Create: `dot_local/bin/executable_nemo-poolside-settings`

- [ ] **Step 1: Write the dconf script**

Create `dot_local/bin/executable_nemo-poolside-settings`:

```bash
#!/usr/bin/env bash
# Apply a minimal-but-identifiable nemo layout for the poolside rice and a
# clean screenshot. MUTATES LIVE DCONF (desktop state), not just repo files.
# Reversal:
#   dconf reset -f /org/nemo/
#   gsettings reset-recursively org.gnome.desktop.interface  # if desired
# Idempotent / re-runnable.
set -euo pipefail

# --- minimal chrome: drop menubar + statusbar, keep path bar + sidebar ---
gsettings set org.nemo.window-state start-with-menu-bar false
gsettings set org.nemo.window-state start-with-status-bar false
gsettings set org.nemo.window-state start-with-sidebar true
gsettings set org.nemo.window-state sidebar-width 180
gsettings set org.nemo.preferences show-location-entry false      # breadcrumb path

# --- clean view for a screenshot ---
gsettings set org.nemo.preferences default-folder-viewer 'icon-view'
gsettings set org.nemo.icon-view default-zoom-level 'large'
gsettings set org.nemo.preferences show-hidden-files false
gsettings set org.nemo.preferences show-image-thumbnails 'always'
gsettings set org.nemo.preferences tooltips-show-path false

# --- make nemo pick up the rice toolkit theme ---
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Poolside'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors-light'

echo "Applied poolside nemo settings (dconf mutated)."
```

- [ ] **Step 2: Apply via chezmoi and run**

Run:
```bash
chezmoi apply -v ~/.local/bin/nemo-poolside-settings && ~/.local/bin/nemo-poolside-settings
```
Expected: `Applied poolside nemo settings (dconf mutated).`

- [ ] **Step 3: Verify the keys round-trip**

Run:
```bash
gsettings get org.nemo.window-state start-with-menu-bar; \
gsettings get org.nemo.preferences default-folder-viewer; \
gsettings get org.gnome.desktop.interface icon-theme
```
Expected: `false`, `'icon-view'`, `'Papirus-Poolside'`.

- [ ] **Step 4: Commit**

```bash
git add dot_local/bin/executable_nemo-poolside-settings
git commit -m "feat(rice): nemo dconf script for minimal poolside layout"
```

---

### Task 7: fastfetch logo — verify on-palette, drop unused slots

**Files:**
- Modify: `dot_config/fastfetch/config.jsonc`

The builtin Arch logo already renders terracotta (slot 1) → pool-blue (slot 2); it only uses two of the four configured color slots. This task confirms that and removes the dead slots 3/4.

- [ ] **Step 1: Confirm the logo uses only slots 1 and 2**

Run:
```bash
fastfetch --logo arch --logo-type builtin 2>/dev/null | grep -oE '38;2;[0-9;]+' | sort -u
```
Expected: two RGB triples — `38;2;212;106;78` (terracotta) and `38;2;61;117;144` (blue). If a default cyan/green appears, keep slots 3/4 instead of removing them and stop.

- [ ] **Step 2: Trim unused color slots in config.jsonc**

Edit `dot_config/fastfetch/config.jsonc` `logo.color` to keep only the slots the Arch logo uses:

```jsonc
    "logo": {
        "color": {
            "1": "38;2;212;106;78",
            "2": "38;2;61;117;144"
        }
    },
```

- [ ] **Step 3: Apply and eyeball**

Run:
```bash
chezmoi apply -v ~/.config/fastfetch/config.jsonc && fastfetch
```
Expected: fetch renders with the terracotta→pool-blue Arch logo and themed keys/title, unchanged from before the trim.

- [ ] **Step 4: Commit**

```bash
git add dot_config/fastfetch/config.jsonc
git commit -m "style(rice): trim fastfetch logo to used poolside color slots"
```

---

### Task 8: Final verification + screenshot readiness

**Files:** none (verification only)

- [ ] **Step 1: chezmoi is clean**

Run:
```bash
chezmoi diff
```
Expected: no output (working `~` matches source).

- [ ] **Step 2: Secret scan**

Run:
```bash
scripts/secret-scan.sh
```
Expected: `Secret scan passed.`

- [ ] **Step 3: Live eyeball for the /r/unixporn shot**

Open nemo and confirm: teal folders, minimal chrome (no menubar/statusbar, breadcrumb path + places sidebar present), pool-blue selection, Inter font.
```bash
nemo "$HOME" &
```
If capturing: follow `memory/showcase-screenshot-workflow.md` (grim needs permission). Capture is optional and left to the user.

- [ ] **Step 4: Confirm branch state**

Run:
```bash
git log --oneline origin/main..HEAD
```
Expected: the per-task commits from this plan on `feat/gtk-icon-nemo-theming`. Pushing/PR is a separate explicit step (see finishing-a-development-branch).
