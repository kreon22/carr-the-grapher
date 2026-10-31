# Decisions

Short log of choices, so we don't re-argue them. Newest at the top.
Format: **date — decision.** Why. (Who: design / code)

**2026-11-01 — Map centered by a `Camera2D` at the origin; hex (0, 0) sits at world (0, 0).** Keeps hex math free of screen offsets and survives window resizes; later systems can move/zoom the camera without touching the grid. (code)

**2026-11-01 — Renderer: GL Compatibility, stretch mode `canvas_items`.** Lightest renderer for a flat 2D ink look; stretch keeps the map proportional when the window resizes. (code)

**2026-11-01 — Tests are plain `SceneTree` scripts in `tests/`, run with `godot --headless -s`, no test framework.** Zero dependencies for now; revisit (e.g. GUT) if tests grow. (code)

**2026-11-01 — `Hex.in_radius(center, radius)` and `Hex.corners()` live in `hex.gd`.** Map generation, drawing, and the upcoming fog `reveal_radius` all need them, and hex math stays in one place. (code)

**2026-10-31 — Engine: Godot 4.x, GDScript only.** Lightweight, good 2D tooling, fits a solo prototype. (design)

**2026-10-31 — Axial hex coordinates (q, r), pointy-top hexes.** Axial keeps neighbor and distance math simple; pointy-top reads naturally for overland maps. (design)

**2026-10-31 — Work split: chat owns `docs/design.md` and `docs/inbox.md`; Claude Code owns code and implements `docs/tasks/`.** Keeps design thinking and implementation from stepping on each other. (design)
