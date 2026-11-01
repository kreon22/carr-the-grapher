# CLAUDE.md — Carr the Grapher

Solo-dev prototype. Godot 4.x, GDScript only.

## Before you start
- Read `docs/design.md` for the vision and pillars. Do not contradict it; if a task seems to, stop and ask.
- Work comes from `docs/tasks/NNN-*.md`. Do one task at a time, meet its acceptance criteria, then set its `Status:` to `done` and commit.
- Record any non-obvious design or architecture choice in `docs/decisions.md` (one short entry).
- Don't edit `docs/design.md` or `docs/inbox.md` — those are owned by the design side (chat).

## Code conventions
- Hex grid uses **axial coordinates** `Vector2i(q, r)`. All hex math lives in one place (`scripts/hex.gd`), nowhere else.
- Decouple with signals; systems don't reach into each other's internals.
- Typed GDScript (`var x: int`, typed function signatures). snake_case files and functions, PascalCase `class_name`.
- Flat, simple structure: `scenes/`, `scripts/`, `assets/`, `tests/`. No deep folder trees.
- Prefer small scripts with one job over large managers.
- Tunable numbers (ink cost, hex size, colors) go in exported vars or a single config resource, not hard-coded inline.

## Running & checking
- Run the game: `godot --path .` (main scene set in project settings).
- Headless sanity check: `godot --headless --path . --quit-after 120` must finish with no script errors.
- If tests exist in `tests/`, run them before committing. Each test is a `SceneTree` script: `godot --headless --path . -s tests/test_hex.gd` (exit code 1 on failure; run every `tests/test_*.gd`). On a fresh checkout run `godot --headless --path . --import` once first so `class_name`s resolve.

## Git
- Small commits, message format: `task NNN: what changed`.
- Push when a task is done so the design side can see it.
