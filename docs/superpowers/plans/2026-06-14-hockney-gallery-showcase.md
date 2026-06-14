# Hockney-gallery nemo + two-scene showcase — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a local Hockney-painting downloader, make nemo an ultra-minimal gallery, and split the desktop showcase into two lighter scenes (system on ws2, gallery on ws3) each captured separately.

**Architecture:** This repo (`/home/jonathan/rice`) is the chezmoi source (copy mode); each task edits a `dot_*` source file, runs `chezmoi apply`, then verifies live. A Python downloader scrapes hockney.com decade pages (titles come from each anchor's `data-caption`, so one request per decade). The showcase script stages two scenes; Hyprland windowrules pin the gallery nemo (matched by class+title) to ws3.

**Tech Stack:** chezmoi, bash, python3, curl, gsettings/dconf, Hyprland windowrules, grim.

**Verified during planning:**
- nemo opened at `~/paintings` reports `class=nemo`, `title=paintings`.
- Combined matcher that actually applies on this Hyprland (0.55.4): `match:class ^(nemo)$, match:title ^(paintings)$` (comma-separated, `match:` on both). Space-separated / `title:` variants silently no-op.
- Decade slugs: `50s 60s 70s 80s 90s 00s 10s 82-portraits`.
- The `data-caption` parser (Task 1 code) produces `1967-a-bigger-splash.jpg`-style names against the live 60s page.

**Note on "tests":** config/scripts, not unit-tested code — each task's verification is a concrete command with expected output plus a live eyeball where visual.

---

### Task 1: Painting downloader

**Files:**
- Create: `dot_local/bin/executable_fetch-hockney-paintings`

- [ ] **Step 1: Write the downloader**

Create `dot_local/bin/executable_fetch-hockney-paintings`:

```python
#!/usr/bin/env python3
"""Download David Hockney paintings from hockney.com into ~/paintings.

LOCAL-ONLY: copyrighted reproductions kept for personal/local desktop use
(a gallery wall in the rice showcase). Never committed to the repo.
Idempotent / re-runnable (skips files already present).
Reversal: rm -rf ~/paintings
"""
import html.parser, os, re, subprocess, sys, time, urllib.request

BASE = "https://www.hockney.com"
DECADES = ["50s", "60s", "70s", "80s", "90s", "00s", "10s", "82-portraits"]
DEST = os.path.expanduser("~/paintings")
UA = "Mozilla/5.0 (X11; Linux) rice-showcase/1.0 (personal use)"
RATE_SLEEP = 0.7  # polite gap between downloads


class GalleryParser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.items = []  # (href, caption)

    def handle_starttag(self, tag, attrs):
        if tag != "a":
            return
        d = dict(attrs)
        href = d.get("href", "") or ""
        cap = d.get("data-caption", "") or ""
        if "img/gallery/paintings/" in href and href.endswith(".jpg"):
            self.items.append((href, cap))


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=20) as r:
        return r.read().decode("utf-8", "replace")


def slugify(cap, href):
    text = re.sub(r"<[^>]+>", " ", cap).replace("\xa0", " ").replace("&nbsp;", " ")
    m = re.search(r"\b(18|19|20)\d{2}\b", text)
    year = m.group(0) if m else ""
    title = text[:m.start()] if m else text
    title = re.sub(r"[^A-Za-z0-9]+", "-", title).strip("-").lower()
    if year and title:
        return f"{year}-{title}.jpg"
    code = href.rsplit("/", 1)[-1].rsplit(".", 1)[0]
    dec = href.rsplit("/", 2)[-2]
    return f"{dec}-{code}.jpg"


def main():
    os.makedirs(DEST, exist_ok=True)
    seen = set()
    got = skip = fail = 0
    for dec in DECADES:
        url = f"{BASE}/works/paintings/{dec}"
        try:
            page = fetch(url)
        except Exception as e:  # noqa: BLE001 - keep going past a bad decade
            print(f"  ! decade {dec}: {e}", file=sys.stderr)
            continue
        p = GalleryParser()
        p.feed(page)
        print(f"{dec}: {len(p.items)} works")
        for href, cap in p.items:
            if not href.startswith("http"):
                href = BASE + "/" + href.lstrip("/")
            if href in seen:
                continue
            seen.add(href)
            name = slugify(cap, href)
            out = os.path.join(DEST, name)
            if os.path.exists(out) and os.path.getsize(out) > 0:
                skip += 1
                continue
            rc = subprocess.run(
                ["curl", "-fsS", "--max-time", "30", "--limit-rate", "2M",
                 "-A", UA, "-o", out, href]
            ).returncode
            if rc == 0 and os.path.exists(out) and os.path.getsize(out) > 0:
                got += 1
                print(f"  + {name}")
            else:
                fail += 1
                if os.path.exists(out):
                    os.remove(out)
                print(f"  ! failed {name}", file=sys.stderr)
            time.sleep(RATE_SLEEP)
    print(f"\nDone. downloaded={got} skipped={skip} failed={fail} dir={DEST}")


if __name__ == "__main__":
    main()
```

- [ ] **Step 2: Apply via chezmoi**

Run:
```bash
chezmoi apply -v ~/.local/bin/fetch-hockney-paintings
```
Expected: chezmoi creates `~/.local/bin/fetch-hockney-paintings` (executable).

- [ ] **Step 3: Smoke-test the parser on one decade (no full download yet)**

Run:
```bash
python3 - <<'PY'
import importlib.util, os
spec = importlib.util.spec_from_file_location("f", os.path.expanduser("~/.local/bin/fetch-hockney-paintings"))
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
page = m.fetch(f"{m.BASE}/works/paintings/60s")
p = m.GalleryParser(); p.feed(page)
print("anchors:", len(p.items))
for href, cap in p.items[:5]:
    print(" ", m.slugify(cap, href))
PY
```
Expected: `anchors: 20` (≈) and names like `1967-a-bigger-splash.jpg`. If 0 anchors, the site markup changed — stop and re-inspect before downloading.

- [ ] **Step 4: Run the full download**

Run:
```bash
~/.local/bin/fetch-hockney-paintings
```
Expected: per-decade counts, `+ <name>` lines, final `Done. downloaded=N skipped=0 failed=…`. A second run prints `skipped=N downloaded=0` (idempotent).

- [ ] **Step 5: Verify the folder**

Run:
```bash
ls ~/paintings | head; echo "count: $(ls ~/paintings | wc -l)"
```
Expected: `<year>-<title>.jpg` files, count well above 50.

- [ ] **Step 6: Commit (script only — images are local-only, never committed)**

```bash
git add dot_local/bin/executable_fetch-hockney-paintings
git commit -m "feat(rice): add hockney.com painting downloader for the gallery"
```

---

### Task 2: nemo ultra-minimal (hide sidebar)

**Files:**
- Modify: `dot_local/bin/executable_nemo-poolside-settings`

- [ ] **Step 1: Flip the sidebar off**

In `dot_local/bin/executable_nemo-poolside-settings`, replace the two sidebar lines:

```bash
gsettings set org.nemo.window-state start-with-sidebar true
gsettings set org.nemo.window-state sidebar-width 180
```

with:

```bash
gsettings set org.nemo.window-state start-with-sidebar false
```

(Leave every other line as-is. This is the "even more minimal" step: menubar, statusbar, and now sidebar are all off; the slim toolbar + breadcrumb stay for navigation.)

- [ ] **Step 2: Apply and run**

Run:
```bash
chezmoi apply -v ~/.local/bin/nemo-poolside-settings && ~/.local/bin/nemo-poolside-settings
```
Expected: `Applied poolside nemo settings (dconf mutated).`

- [ ] **Step 3: Verify the sidebar key**

Run:
```bash
gsettings get org.nemo.window-state start-with-sidebar
```
Expected: `false`.

- [ ] **Step 4: Commit**

```bash
git add dot_local/bin/executable_nemo-poolside-settings
git commit -m "feat(rice): hide nemo sidebar for the minimal gallery layout"
```

---

### Task 3: Hyprland rules — drop weather, add gallery

**Files:**
- Modify: `dot_config/hypr/hyprland.conf`

- [ ] **Step 1: Remove the rice_weather rule block**

Delete these three lines (the weather comment + two rules, currently around lines 108-110):

```
# weather — compact poolside forecast card, top-right against the pool house.
windowrule = size 470 200, match:class ^(rice_weather)$
windowrule = move 1330 150, match:class ^(rice_weather)$
```

- [ ] **Step 2: Add the gallery rule block**

After the cava rule block (the two `rice_cava` lines), add:

```
# gallery — Hockney paintings in nemo, its own scene on workspace 3 for a
# second, lighter screenshot. nemo can't take a custom --class under Wayland,
# so these match on the window title (verified: class=nemo, title=paintings).
# Caveat: opening ~/paintings manually will also dock here — rename the folder
# or remove these rules to opt out.
windowrule = workspace 3, match:class ^(nemo)$, match:title ^(paintings)$
windowrule = float 1, match:class ^(nemo)$, match:title ^(paintings)$
windowrule = opacity 1.0 override 1.0 override, match:class ^(nemo)$, match:title ^(paintings)$
windowrule = rounding 10, match:class ^(nemo)$, match:title ^(paintings)$
windowrule = size 900 600, match:class ^(nemo)$, match:title ^(paintings)$
windowrule = move 510 240, match:class ^(nemo)$, match:title ^(paintings)$
```

- [ ] **Step 3: Apply and reload Hyprland**

Run:
```bash
chezmoi apply -v ~/.config/hypr/hyprland.conf && hyprctl reload
```
Expected: `ok`. (`hyprctl reload` re-reads config; it does not restart the session.)

- [ ] **Step 4: Verify the gallery rule actually floats + positions nemo**

Run:
```bash
nohup nemo ~/paintings >/dev/null 2>&1 & sleep 2
hyprctl clients -j | python3 -c 'import json,sys
for c in json.load(sys.stdin):
    if c.get("class")=="nemo" and c.get("title")=="paintings":
        print("workspace=",c["workspace"]["id"],"floating=",c.get("floating"),"at=",c.get("at"),"size=",c.get("size"))'
```
Expected: `workspace= 3 floating= True at= [510, 240] size= [900, 600]`. Then close it:
```bash
hyprctl clients -j | python3 -c 'import json,sys,subprocess
for c in json.load(sys.stdin):
    if c.get("class")=="nemo": subprocess.run(["hyprctl","dispatch","closewindow","address:"+c["address"]])'
```

- [ ] **Step 5: Commit**

```bash
git add dot_config/hypr/hyprland.conf
git commit -m "feat(hypr): swap showcase weather pane for a ws3 gallery nemo"
```

---

### Task 4: Rewrite rice-showcase for two scenes

**Files:**
- Modify (full rewrite): `dot_local/bin/executable_rice-showcase`

- [ ] **Step 1: Replace the script**

Overwrite `dot_local/bin/executable_rice-showcase` with:

```bash
#!/usr/bin/env bash
#
# rice-showcase — stage two floating "desktop showcase" scenes over the
# wallpaper and screenshot them. Sizes/positions live as windowrules in
# hyprland.conf so each scene is identical every time. Toggle with Alt+Shift+S.
#
#   Scene A "system"  (workspace 2): rice_fetch (fastfetch) + rice_cava (cava,
#                                    or an eza listing if cava is missing).
#   Scene B "gallery" (workspace 3): nemo at ~/paintings — a Hockney gallery
#                                    wall (populated by fetch-hockney-paintings).
#
# `shot` captures one PNG per scene so neither buries the wallpaper.
#
set -euo pipefail

KENV=(env LIBGL_ALWAYS_SOFTWARE=1 kitty)
SYSTEM_WS="${RICE_SHOWCASE_WS:-2}"
GALLERY_WS=3
GALLERY_DIR="$HOME/paintings"
STATE="${XDG_RUNTIME_DIR:-/tmp}/rice-showcase.ws"

# Addresses of every window belonging to the showcase: the rice_ kitty panes
# plus the gallery nemo (class nemo, title paintings).
show_addresses() {
    hyprctl clients -j 2>/dev/null | python3 -c 'import json,sys
for c in json.load(sys.stdin):
    cls=c.get("class","")
    if cls.startswith("rice_") or (cls=="nemo" and c.get("title")=="paintings"):
        print(c["address"])'
}

scene_is_up() {
    [ -n "$(show_addresses)" ]
}

launch_pane() {
    setsid -f "${KENV[@]}" "$@" >/dev/null 2>&1
}

dismiss() {
    # Close every showcase window by address (closing by shared class can resolve
    # repeated dispatches to the same window, stranding others).
    for _ in $(seq 1 10); do
        mapfile -t addrs < <(show_addresses)
        [ "${#addrs[@]}" -eq 0 ] && break
        for a in "${addrs[@]}"; do
            hyprctl dispatch closewindow "address:$a" >/dev/null 2>&1 || true
        done
        sleep 0.3
    done
    if [ -f "$STATE" ]; then
        prev="$(cat "$STATE" 2>/dev/null || true)"
        [ -n "$prev" ] && hyprctl dispatch workspace "$prev" >/dev/null 2>&1 || true
        rm -f "$STATE"
    fi
}

summon() {
    # Remember the current workspace; windowrules pin each pane to its own
    # workspace, so launch order / active workspace don't matter.
    hyprctl activeworkspace -j 2>/dev/null \
        | grep -oE '"id": *-?[0-9]+' | head -1 | grep -oE '\-?[0-9]+' > "$STATE" || true
    hyprctl dispatch workspace "$SYSTEM_WS" >/dev/null 2>&1 || true

    # Scene A — system
    launch_pane --class rice_fetch --title fastfetch bash -lc 'fastfetch; tail -f /dev/null'
    if command -v cava >/dev/null 2>&1; then
        launch_pane --class rice_cava --title cava bash -lc 'cava || true; tail -f /dev/null'
    else
        launch_pane --hold --class rice_cava \
            bash -lc 'eza -la --icons --git ~/rice 2>/dev/null; echo; echo "  (install cava for an audio visualiser in this pane)"'
    fi

    # Scene B — gallery (nemo pinned to GALLERY_WS by windowrule)
    if [ -d "$GALLERY_DIR" ] && [ -n "$(ls -A "$GALLERY_DIR" 2>/dev/null)" ]; then
        setsid -f nemo "$GALLERY_DIR" >/dev/null 2>&1
    else
        echo "note: $GALLERY_DIR is empty — run fetch-hockney-paintings first" >&2
    fi
}

# Capture both scenes. cava only reacts to live audio, so play the test tone
# before grabbing the system scene.
shot() {
    local base="${1:-$HOME/rice/screenshots/showcase-$(date +%Y%m%d-%H%M%S)}"
    mkdir -p "$(dirname "$base")"
    scene_is_up || { summon; sleep 2; }

    if [ -x "$HOME/.local/bin/cava-tone" ]; then
        setsid -f "$HOME/.local/bin/cava-tone" 20 >/dev/null 2>&1 || true
        for _ in $(seq 1 20); do pgrep -x pw-play >/dev/null && break; sleep 0.5; done
        sleep 2
    fi

    hyprctl dispatch workspace "$SYSTEM_WS" >/dev/null 2>&1 || true
    sleep 0.6
    command -v grim >/dev/null 2>&1 && grim "${base}-system.png" && echo "saved ${base}-system.png"

    hyprctl dispatch workspace "$GALLERY_WS" >/dev/null 2>&1 || true
    sleep 1.5   # let nemo render thumbnails
    command -v grim >/dev/null 2>&1 && grim "${base}-gallery.png" && echo "saved ${base}-gallery.png"
}

case "${1:-toggle}" in
    up|summon|on)   summon ;;
    down|reset|off) dismiss ;;
    shot|capture)   shift; shot "${1:-}" ;;
    toggle|"")      if scene_is_up; then dismiss; else summon; fi ;;
    *) echo "usage: rice-showcase [toggle|up|down|shot [base-path]]" >&2; exit 2 ;;
esac
```

- [ ] **Step 2: Apply**

Run:
```bash
chezmoi apply -v ~/.local/bin/rice-showcase
```
Expected: chezmoi updates `~/.local/bin/rice-showcase`.

- [ ] **Step 3: Summon and verify both scenes exist on the right workspaces**

Run:
```bash
~/.local/bin/rice-showcase up; sleep 2
hyprctl clients -j | python3 -c 'import json,sys
for c in json.load(sys.stdin):
    cls=c.get("class","")
    if cls.startswith("rice_") or (cls=="nemo" and c.get("title")=="paintings"):
        print(cls, "ws", c["workspace"]["id"], "floating", c.get("floating"))'
```
Expected: `rice_fetch ws 2`, `rice_cava ws 2`, `nemo ws 3 floating True`.

- [ ] **Step 4: Dismiss and verify cleanup**

Run:
```bash
~/.local/bin/rice-showcase down; sleep 1
hyprctl clients -j | python3 -c 'import json,sys
n=[c for c in json.load(sys.stdin) if c.get("class","").startswith("rice_") or (c.get("class")=="nemo" and c.get("title")=="paintings")]
print("remaining showcase windows:", len(n))'
```
Expected: `remaining showcase windows: 0`.

- [ ] **Step 5: Commit**

```bash
git add dot_local/bin/executable_rice-showcase
git commit -m "feat(rice): two-scene showcase (system + Hockney gallery)"
```

---

### Task 5: End-to-end verification

**Files:** none (verification only)

- [ ] **Step 1: Capture both scenes**

Run:
```bash
~/.local/bin/rice-showcase shot /tmp/showcase-test
ls -l /tmp/showcase-test-system.png /tmp/showcase-test-gallery.png
```
Expected: both PNGs saved and non-empty.

- [ ] **Step 2: Eyeball the gallery shot**

Open `/tmp/showcase-test-gallery.png`: a centered 900×600 nemo wall of Hockney thumbnails with filename captions (e.g. "1967 a bigger splash"), no sidebar/menubar/statusbar, wallpaper framing it. The system shot shows fastfetch + cava with open wallpaper top-right.

- [ ] **Step 3: Dismiss and confirm clean state**

Run:
```bash
~/.local/bin/rice-showcase down
chezmoi diff -- ~/.local/bin/rice-showcase ~/.local/bin/fetch-hockney-paintings ~/.local/bin/nemo-poolside-settings ~/.config/hypr/hyprland.conf
scripts/secret-scan.sh
```
Expected: no diff for the managed files; `Secret scan passed.`

- [ ] **Step 4: Confirm branch commits**

Run:
```bash
git log --oneline main..HEAD
```
Expected: the per-task commits from this plan plus the earlier theming commits. `~/paintings/` does not appear in any commit (local-only). Pushing/PR is a separate explicit step.
