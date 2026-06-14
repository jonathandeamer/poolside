# Waybar Hockney Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-theme the floating Waybar into a flat-plane Hockney "A Bigger Splash" composition — pool-blue workspaces and terracotta clock as the two saturated hero planes, muted neutral surrounds, blur-less hard shadows, crisp corners — without changing modules or layout.

**Architecture:** Pure CSS edits to the chezmoi-managed `dot_config/waybar/style.css`. No `config` changes (layout and modules stay identical). Each task edits one logical group of rules, then applies via chezmoi, reloads Waybar with `SIGUSR2`, is visually verified, and committed.

**Tech Stack:** Waybar GTK CSS, chezmoi (source repo at `/home/jonathan/rice`), Hyprland.

---

## Domain note: how "verify" works here

There are no unit tests for Waybar CSS. For every task the verification loop is:

```bash
# 1. apply the edited source to the live config
chezmoi apply ~/.config/waybar/style.css
# 2. hot-reload Waybar's style (does NOT touch the compositor)
killall -SIGUSR2 waybar
```

Then **look at the bar** to confirm the described visual result. A screenshot is
optional (`grim` needs an interactive permission grant the first time — see the
showcase-screenshot memory). Reloading Waybar is safe and is **not** a forbidden
session-level command (it does not restart Hyprland).

All edits are to the source file `dot_config/waybar/style.css` (which chezmoi maps
to `~/.config/waybar/style.css`). Always edit the **source**, then `chezmoi apply`.

Commit style: Conventional Commits, scope `waybar`, **no AI attribution** (the hook
rejects it). The `secret-scan` pre-commit hook will run; these CSS edits contain no
secrets.

---

## File Structure

- Modify: `dot_config/waybar/style.css` — the only file touched.
- `dot_config/waybar/config` — **unchanged** (layout/modules already correct).

---

## Task 1: Hard-light language (crisp corners + blur-less shadows)

Makes every floating chip a sharp, hard-lit cut-paper plane. Bar still looks cream
at this point — only corners and shadows change.

**Files:**
- Modify: `dot_config/waybar/style.css`

- [ ] **Step 1: Tighten the global corner radius**

In the `*` block, change the radius from `8px` to `4px`.

Find:
```css
  border-radius: 8px;
```
Replace with:
```css
  border-radius: 4px;
```

- [ ] **Step 2: Add a blur-less hard shadow to the main chip group**

Find:
```css
#workspaces,
#window,
#clock,
#network,
#tray {
  margin: 5px 4px 4px;
  padding: 0 10px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
}
```
Replace with:
```css
#workspaces,
#window,
#clock,
#network,
#tray {
  margin: 5px 4px 4px;
  padding: 0 10px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
  box-shadow: 2px 2px 0 rgba(35, 49, 58, 0.18);
}
```

- [ ] **Step 3: Add the same shadow to the control glyph chip**

Find:
```css
#custom-control {
  margin: 5px 4px 4px;
  padding: 0 11px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
  color: #3d7590;
  font-size: 15px;
}
```
Replace with:
```css
#custom-control {
  margin: 5px 4px 4px;
  padding: 0 11px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
  color: #3d7590;
  font-size: 15px;
  box-shadow: 2px 2px 0 rgba(35, 49, 58, 0.18);
}
```

- [ ] **Step 4: Add the same shadow to the revealed drawer chips**

Find:
```css
#group-control #wireplumber,
#group-control #network {
  margin: 5px 2px 4px;
  padding: 0 10px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
  color: #23313a;
  min-width: 0;
}
```
Replace with:
```css
#group-control #wireplumber,
#group-control #network {
  margin: 5px 2px 4px;
  padding: 0 10px;
  background: rgba(245, 240, 232, 0.78);
  border: 1px solid rgba(201, 98, 68, 0.2);
  color: #23313a;
  min-width: 0;
  box-shadow: 2px 2px 0 rgba(35, 49, 58, 0.18);
}
```

- [ ] **Step 5: Apply and reload**

Run:
```bash
chezmoi apply ~/.config/waybar/style.css && killall -SIGUSR2 waybar
```
Expected: bar reloads with no errors; chips now have noticeably sharper corners and
a small hard (no-blur) shadow toward the bottom-right of each chip. Still cream.

- [ ] **Step 6: Commit**

```bash
git add dot_config/waybar/style.css
git commit -m "style(waybar): crisp corners and hard-light flat shadows"
```

---

## Task 2: Hero plane #1 — pool-blue workspaces

Turns the workspaces chip into the flat blue "pool" and makes the dots legible on
it: faint cream inactive dots, terracotta active dot, **no underline**.

**Files:**
- Modify: `dot_config/waybar/style.css`

- [ ] **Step 1: Make the workspaces chip a flat pool-blue plane**

Find:
```css
#workspaces {
  padding-left: 7px;
  padding-right: 7px;
  background: rgba(252, 250, 246, 0.9);
  border-color: rgba(212, 106, 78, 0.3);
}
```
Replace with:
```css
#workspaces {
  padding-left: 7px;
  padding-right: 7px;
  background: #3d7590;
  border: none;
}
```

- [ ] **Step 2: Shift inactive dots to faint cream so they read on blue**

Find:
```css
#workspaces button {
  min-width: 18px;
  padding: 0 3px;
  margin: 0 2px;
  background: transparent;
  color: rgba(61, 117, 144, 0.8);
  border: 1px solid transparent;
  font-size: 11px;
}
```
Replace with:
```css
#workspaces button {
  min-width: 18px;
  padding: 0 3px;
  margin: 0 2px;
  background: transparent;
  color: rgba(252, 250, 246, 0.6);
  border: 1px solid transparent;
  font-size: 11px;
}
```

- [ ] **Step 3: Keep the terracotta active dot but remove the underline**

Find:
```css
#workspaces button.active {
  min-width: 18px;
  background: transparent;
  color: #d46a4e;
  border-bottom: 2px solid rgba(212, 106, 78, 0.95);
}
```
Replace with:
```css
#workspaces button.active {
  min-width: 18px;
  background: transparent;
  color: #d46a4e;
}
```

- [ ] **Step 4: Apply and reload**

Run:
```bash
chezmoi apply ~/.config/waybar/style.css && killall -SIGUSR2 waybar
```
Expected: the left chip is now a solid flat pool-blue rectangle. Inactive
workspaces show as faint cream dots; the active workspace is a terracotta dot with
**no** line/underline beneath it. All dots clearly legible against the blue.

- [ ] **Step 5: Commit**

```bash
git add dot_config/waybar/style.css
git commit -m "style(waybar): pool-blue workspaces plane, drop active underline"
```

---

## Task 3: Hero plane #2 — terracotta clock

Makes the center clock the warm terracotta "diving board" focal block with cream
text and slightly more deliberate type.

**Files:**
- Modify: `dot_config/waybar/style.css`

- [ ] **Step 1: Recolor the clock to a flat terracotta plane**

Find:
```css
#clock {
  background: rgba(238, 227, 213, 0.9);
  color: #7d3c31;
  border-color: rgba(212, 106, 78, 0.28);
}
```
Replace with:
```css
#clock {
  background: #c96244;
  color: #fcfaf6;
  border: none;
  font-weight: 600;
  letter-spacing: 0.3px;
}
```

- [ ] **Step 2: Apply and reload**

Run:
```bash
chezmoi apply ~/.config/waybar/style.css && killall -SIGUSR2 waybar
```
Expected: the center clock is now a solid terracotta block with cream text, set in a
slightly heavier weight with a touch more letter-spacing. Text clearly legible.

- [ ] **Step 3: Commit**

```bash
git add dot_config/waybar/style.css
git commit -m "style(waybar): terracotta clock hero with cream text"
```

---

## Task 4: Neutral surround — muted sand window title

Pushes the window-title chip to a muted sand so the two hero planes carry the color
and the title recedes for readability. (Control glyph, drawer chips, and tray are
already neutral cream and keep their faint borders — no change needed.)

**Files:**
- Modify: `dot_config/waybar/style.css`

- [ ] **Step 1: Recolor the window title chip to muted sand**

Find:
```css
#window {
  background: rgba(244, 224, 189, 0.62);
  color: #23313a;
}
```
Replace with:
```css
#window {
  background: rgba(227, 222, 214, 0.85);
  color: #23313a;
}
```

- [ ] **Step 2: Apply and reload**

Run:
```bash
chezmoi apply ~/.config/waybar/style.css && killall -SIGUSR2 waybar
```
Expected: the window-title chip is now a quiet sand/cream plane (keeps its faint
terracotta hairline border), visibly more neutral than the blue and terracotta
heroes; dark title text stays legible. The empty-window hide behaviour still works
(title chip disappears when no window is focused).

- [ ] **Step 3: Commit**

```bash
git add dot_config/waybar/style.css
git commit -m "style(waybar): mute window title to sand neutral"
```

---

## Task 5: Final visual review

**Files:** none (review only).

- [ ] **Step 1: Reload and review the whole composition**

Run:
```bash
chezmoi apply ~/.config/waybar/style.css && killall -SIGUSR2 waybar
```
Confirm against the spec's success criteria:
- Two saturated planes read clearly: blue pool (left, workspaces) and terracotta
  board (center, clock).
- Surrounds (window title, control glyph, drawer, tray) are muted neutrals.
- Hard, blur-less shadows under every chip; crisp ~4px corners throughout.
- Workspace dots: terracotta active (no underline), faint cream inactive, all legible.
- Clock text (cream on terracotta) and window title (dark on sand) both legible.

- [ ] **Step 2: Optional showcase screenshot**

If capturing for /r/unixporn, follow the showcase-screenshot workflow (grim needs a
one-time permission grant; see memory). Not required for completion.

- [ ] **Step 3: Confirm clean tree**

```bash
git status
```
Expected: working tree clean; all redesign commits present.

---

## Self-review notes

- **Spec coverage:** color planes (Tasks 2–4), workspace dots + underline removal
  (Task 2), hard shadows + crisp corners (Task 1), clock typography (Task 3),
  neutral surrounds (Tasks 1 are already-neutral controls/tray + Task 4 window).
  No splash glyph (correctly omitted per final spec). No module/layout change.
- **Placeholder scan:** every CSS edit shows exact before/after; no TODOs.
- **Consistency:** the shadow value `2px 2px 0 rgba(35,49,58,0.18)` and radius `4px`
  are identical everywhere they appear; the terracotta `#c96244`, pool-blue
  `#3d7590`, and active-dot `#d46a4e` match the spec table.
