# Waybar Hockney "A Bigger Splash" Redesign

## Goal

Re-theme the Waybar so it reads as a deliberate Hockney "A Bigger Splash"
composition and stands out on /r/unixporn, without adding modules or changing the
existing layout. The bar stays **floating** (detached, rounded, with margins) and
**minimal** (same modules it runs today). The redesign is purely visual: color,
shadow, corner, and typography language.

## Principles

- **Flat color, not gradients.** Hockney's planes are flat, saturated, hard-edged.
- **Two hero planes, neutral surrounds.** Restraint is what keeps color-blocking
  from looking garish — a big flat blue pool and a terracotta diving board as the
  only saturated accents, everything else muted.
- **Hard California light.** Crisp edges and blur-less cast shadows so chips read as
  cut-paper planes lifted off the wallpaper.

## Scope

- Files: `dot_config/waybar/style.css` (primary), `dot_config/waybar/config`
  (only if a module/format tweak is needed — not expected).
- No new modules, no layout/position change, no new dependencies.
- Layout stays: left = workspaces + window title; center = clock; right = control
  group (sliders glyph → drawer with wireplumber + network) + tray.

## Composition & color planes

Mapping the existing left → center → right layout onto the painting:

| Module | Role | Color | Text | Rationale |
|---|---|---|---|---|
| Workspaces (left) | **Hero #1** | flat pool-blue `#3d7590` | dots, see below | the pool |
| Window title | neutral | muted sand/cream (~`#e3ded6`) | `#23313a` | patio/building; recedes for readability |
| Clock (center) | **Hero #2** | flat terracotta `#c96244` | cream `#fcfaf6` | the diving board; warm central focus |
| Control glyph + drawer | neutral | muted cream; glyph in pool-blue `#3d7590` | — | ties back to the pool; revealed chips stay neutral |
| Tray | neutral | muted cream | — | quiet corner |

Net read: blue plane left, terracotta plane center, calm neutral planes around them.

## Workspace indicators

- Keep the existing dot language: active = filled terracotta dot `●` (`#d46a4e`),
  inactive = `○`.
- **Remove** the active-dot underline (the current
  `border-bottom: 2px solid rgba(212,106,78,0.95)` on `#workspaces button.active`).
- **Required fix from the new blue plane:** inactive dots are currently pool-blue
  (`rgba(61,117,144,0.8)`) and would vanish on the blue plane. Shift inactive dots
  to a **muted cream** so they read on blue. Active stays the terracotta dot.
- Result on the blue plane: faint cream dots, one terracotta dot, no underline.
- No splash glyph (considered and dropped — the color composition carries the theme).

## Hard-light detail language

1. **Hard offset shadow** on each floating chip — blur-less, e.g.
   `box-shadow: 2px 2px 0 rgba(35,49,58,0.18)` — flat cut-paper / hard-light look.
2. **Crisper corners** — drop chip `border-radius` from `8px` to ~`4px`.
3. **Borders** — drop the thin terracotta outlines on the saturated (blue/terracotta)
   planes so the flat color stays clean; keep a faint border only on the neutral
   cream chips for definition.
4. **Typography** — keep Inter 13px / weight 500 globally. Bump the **center clock**
   only to weight 600 with a hair of letter-spacing so the terracotta hero reads as
   deliberate.

## Out of scope / non-goals

- No splash motif / new glyphs.
- No new modules (no launcher glyph, no system stats, no now-playing).
- No layout, position, or full-width change — stays floating and minimal.
- No font change.

## Success criteria

- Bar reads as two saturated Hockney planes (blue pool left, terracotta board
  center) on muted neutral surrounds, with blur-less hard shadows and crisp corners.
- Workspace dots: terracotta active (no underline), faint cream inactive, all legible
  on the blue plane.
- Clock text legible (cream on terracotta); window title legible (dark on sand).
- Change is contained to the waybar CSS (and config only if strictly necessary),
  reversible via git.
