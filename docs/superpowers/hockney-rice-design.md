# Hockney Rice Design

This document translates `docs/hockney-aesthetic.md` into a desktop rice direction. It is a design
brief, not an implementation checklist. It should guide later Hyprland, Waybar, launcher,
notification, terminal, wallpaper, and script decisions without locking in technical details yet.

## Design Thesis

The desktop should feel like a Hockney pool painting became an operating environment:

- quiet modernist structure
- clean California daylight
- broad acrylic color planes
- shallow staged space
- thin framing lines
- one or two lively water-like gestures
- domestic warmth rather than sterile minimalism

The rice should not look like a generic beach theme. It should feel composed, intelligent, light,
and humane: a place to work inside, not a poster pasted behind a terminal.

## Three Candidate Directions

### Pool House

The most direct interpretation.

This direction treats the desktop as a calm architectural field: pool blue background, pale concrete
surfaces, restrained pink or cream planes, dark glass accents, and occasional white water marks. It
is closest to `A Bigger Splash` and `Peter Getting Out of Nick's Pool`.

Strengths:

- Immediately reads as Hockney-adjacent.
- Works naturally for a tiling desktop because rectangles, bands, and borders are central.
- Supports a clean, legible daily driver.

Risks:

- Can become too literal if every element becomes pool-themed.
- Can drift into generic pastel minimalism if the marks and contrasts are too polite.

### Sprinkler Lawn

The most patterned interpretation.

This direction takes `A Lawn Being Sprinkled` as the primary reference: lawn green fields, repeated
short marks, pale spray triangles, thin warm borders, gray house mass, and sky blue air.

Strengths:

- More distinctive than a pool-blue theme.
- Gives a clear language for texture, repetition, and motion.
- Could make workspace states and subtle separators feel like sprinkler rhythm.

Risks:

- Green can dominate too easily.
- Dense texture could make the desktop noisy.

### Santa Monica Interior

The most humane and understated interpretation.

This direction borrows from `Christopher Isherwood and Don Bachardy`: pale walls, blue shutters,
woven tan texture, book-stack blocks, fruit yellow, white shirts, soft shadows, and a spacious room.

Strengths:

- Captures the social and domestic Hockney, not just pools.
- Better for long work sessions because it is gentler and less saturated.
- Creates room for tasteful object-like UI pieces.

Risks:

- May read as simply mid-century interior design unless the color and line vocabulary stay specific.
- Less immediately recognizable as a Hockney tribute.

## Recommended Blend

Use `Pool House` as the structural base, `Santa Monica Interior` for warmth, and `Sprinkler Lawn`
only as an accent language.

In practice, this means the core desktop should be pale, blue, rectilinear, and sunlit. The warmer
human notes come from pink stucco, cream, tan, yellow, and book-like blocks. The lively details come
from water squiggles, glass glints, thin red-orange borders, and sparse grass/sprinkler marks.

The guiding ratio:

- 70 percent quiet architectural planes
- 20 percent domestic warmth
- 10 percent water or lawn gesture

If the rice starts feeling busy, remove gesture first. If it starts feeling generic, add one sharper
Hockney sign: a red-orange border, a glass reflection mark, a hard pool line, or a suspended splash.

## Desktop Atmosphere

The desktop should feel like afternoon, not night.

It should be bright enough to break from common dark Linux rices, but not so bright that text work
becomes tiring. Think pale concrete in shade, not full white sun. The surface should be calm and
matte. Avoid glossy translucency and blur-heavy glass effects; Hockney's glass is drawn with lines
and reflections, not simulated with operating-system blur.

Good emotional words:

- clear
- still
- warm
- observant
- dry
- airy
- staged
- social
- lightly playful

Bad emotional words:

- neon
- moody
- cinematic
- glossy
- cyber
- tropical
- maximal
- cute
- retro-kitsch

## Palette Concept

Do not begin with a conventional terminal theme. Begin with picture planes.

Primary planes:

- Pool blue: the main cool identity.
- Pale concrete: the work surface.
- Warm white: the border and breathing room.
- Stucco pink: the architectural counterweight.

Secondary planes:

- Lawn green: living accent, not a universal background.
- Charcoal glass: contrast and depth.
- Shutter blue-gray: quiet structure.
- Woven tan: domestic warmth.

Event colors:

- White splash: motion and highlights.
- Lemon yellow: small moments of optimism.
- Red-orange border: frame, warning, and compositional snap.
- Lavender/violet: rare interior accent.

Color behavior:

- Keep colors mostly flat.
- Let single colors own whole regions.
- Prefer hard transitions to gradients.
- Use contrast by adjacency, not glow.
- Use black sparingly; favor charcoal, slate, and deep green-black.

## Form Language

The rice should be rectangular, but not brutally mechanical.

Core shapes:

- long horizontal bands
- large rectangles
- thin frames
- square image-like surfaces
- narrow vertical posts
- shallow overlapping planes
- occasional triangular spray forms

Edges should be mostly straight and crisp. Radius, when used, should be restrained. The Hockney
reference is modernist architecture and painting borders, not rounded app-store cards.

The strongest form pattern is a frame inside a frame: a desktop surface that knows it is a picture,
with thin borders and carefully placed fields.

## Texture And Marks

Texture should be rare and intentional.

Possible mark families:

- white water squiggles
- diagonal glass glints
- repeated grass strokes
- shutter stripes
- woven chair-like bands
- thin red-orange picture-frame lines

These marks should work like painterly punctuation. They should not cover every surface. A single
well-placed mark can do more than a full patterned wallpaper.

The texture should feel hand-drawn or painted, not generated noise.

## Wallpaper Direction

The wallpaper should carry most of the tribute, so interface components can stay functional.

Good wallpaper concepts:

- An abstract pool-house composition with sky, wall, water, and diving-board-like plane.
- A pale concrete field with a hard pool edge and one suspended white splash.
- A Santa Monica room abstraction: blue shutters, pale wall, table plane, lemon/yellow object.
- A lawn/sprinkler abstraction used only if the rest of the UI is very quiet.

Avoid using a copyrighted Hockney painting directly as the wallpaper in the public repo. A generated
or hand-built homage is safer and more personal: similar concerns, different image.

## Window And Layout Feeling

Windows should feel like panes in a modern house.

The tiling layout naturally suits the aesthetic: rectangles, frames, glass, shutters, and staged
rooms. The goal should be calm placement rather than floating chaos. Floating windows can exist, but
they should feel like art objects or books placed on a table, not random panels.

Design ideas to explore later:

- active windows as warm-framed picture planes
- inactive windows as pale concrete or glass panes
- workspace transitions that feel like moving between rooms
- focused state as a thin red-orange or pool-blue frame
- urgent state as a small splash/event, not a huge alarm

## Bar Direction

The bar should feel like an architectural band.

It should be slim, deliberate, and calm. It can borrow from rooflines, pool edges, shutter rails, or
the thin borders around Hockney's paintings. It should not be a bulky control dashboard.

Design ideas to explore later:

- segments as shallow rectangular blocks
- current workspace as a pool tile or framed picture
- status modules arranged with generous spacing
- one bright accent for the active state
- very limited icons, used cleanly

## Launcher Direction

The launcher should feel like a staged domestic object, not a command bunker.

It can take cues from books, table objects, and interior planes: a centered rectangle, pale surface,
clean list, perhaps a narrow color stripe or shutter-like selection state. It should be fast and
plain enough for daily use.

Design ideas to explore later:

- selection as a blue shutter stripe or pink plane
- prompt as a thin architectural line
- minimal shadows with hard direction
- no heavy blur

## Notifications Direction

Notifications should be small composed cards, closer to labels in a painting than system popups.

They can use pale concrete, warm white, and a thin accent border. Urgency should be expressed with
color and line before size. A notification should feel like a note placed on a poolside table.

## Terminal Direction

The terminal must remain highly legible.

It should borrow atmosphere without sacrificing contrast. The best direction is probably a light or
soft-light theme with charcoal text and strong syntax colors, plus an optional darker glass variant
for long coding sessions.

Terminal design should avoid novelty. Hockney's contribution here is clarity, color separation, and
surface discipline, not decorative prompts everywhere.

## Interaction Motion

Motion should be sparse and event-like.

The design language is not continuous animation. It is a still scene interrupted by a splash,
sprinkler, glint, or shift of light. Any animation should be brief, directional, and meaningful.

Good motion metaphors:

- a quick ripple
- a glint crossing glass
- a splash appearing and settling
- a panel sliding like a shutter
- a room-to-room transition

Avoid constant bobbing, liquid blobs, bokeh, or decorative animated gradients.

## Soundness Test

When evaluating a proposed detail, ask:

- Does it feel like daylight?
- Is it composed from planes, lines, and a few marks?
- Is there enough stillness around the event?
- Would it still work if the Hockney references were removed?
- Is it respectful without copying?
- Is it usable for a real work session?

If the answer fails, simplify.

## First Design Milestones

The likely design order should be:

1. Define the palette from the reference set.
2. Create or choose an original homage wallpaper.
3. Establish Hyprland border, gap, and shadow language.
4. Style Waybar as the architectural band.
5. Style Wofi and Mako as staged objects.
6. Tune Kitty for legibility within the palette.
7. Add one subtle mark language, such as glints or water lines.

Do not start by changing every component at once. The rice should develop like a painting: large
planes first, then structure, then objects, then marks.

## Working Direction

Build a bright, calm, pool-house desktop: pale concrete work surfaces, pool-blue identity, pink
stucco warmth, charcoal glass contrast, thin red-orange framing, and sparse white water marks. It
should feel modern, humane, and observant, with motion treated as a rare event inside a composed
scene.
