# Decisions

Short log of choices, so we don't re-argue them. Newest at the top.
Format: **date — decision.** Why. (Who: design / code)

**2026-10-31 — Engine: Godot 4.x, GDScript only.** Lightweight, good 2D tooling, fits a solo prototype. (design)

**2026-10-31 — Axial hex coordinates (q, r), pointy-top hexes.** Axial keeps neighbor and distance math simple; pointy-top reads naturally for overland maps. (design)

**2026-10-31 — Work split: chat owns `docs/design.md` and `docs/inbox.md`; Claude Code owns code and implements `docs/tasks/`.** Keeps design thinking and implementation from stepping on each other. (design)
