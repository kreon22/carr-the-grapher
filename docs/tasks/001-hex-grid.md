# 001 — Hex grid on screen

Status: todo

## Goal
A Godot 4 project that opens a window and draws a hex grid. This is the foundation everything else stands on.

## Scope
- Create the Godot project (`project.godot`) with a main scene `scenes/main.tscn`.
- `scripts/hex.gd` (`class_name Hex`): static axial helpers — `to_world(q_r: Vector2i, size: float) -> Vector2`, `from_world(pos: Vector2, size: float) -> Vector2i` (with proper cube rounding), `neighbors(q_r) -> Array[Vector2i]`, `distance(a, b) -> int`. Pointy-top hexes.
- `scripts/hex_grid.gd`: generates a hex-shaped map of radius N (exported, default 6), draws hex outlines in an ink-on-parchment style (dark brown lines on a light parchment background — plain colors are fine for now).
- Mouse hover highlights the hex under the cursor (proves `from_world` works).

## Acceptance criteria
- `godot --path .` opens a window with a visible hex map centered on screen.
- Hovering highlights exactly the hex under the mouse, including at edges.
- Headless check passes with no script errors.
- If practical, a small test in `tests/` checks `to_world`/`from_world` round-trip and `distance`.

## Out of scope
Player, fog, ink, rivers.
