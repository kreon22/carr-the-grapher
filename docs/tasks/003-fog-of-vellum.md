# 003 — Fog of vellum

Status: todo
Depends on: 002

## Goal
The world starts hidden; walking reveals it. First moment the game *feels* like exploration.

## Scope
- Track visited hexes (a `Dictionary` or `Set`-like structure keyed by `Vector2i`), owned by one small script.
- Unvisited hexes are covered by a dark parchment fill (flat dark color is fine now; texture comes later).
- On `moved`, reveal the hex Carr entered. Starting hex is revealed at start.
- Open design question to *leave configurable*: also reveal neighbors of the current hex? Export a `reveal_radius` (default 0 = only the hex itself), so we can feel both in play.

## Acceptance criteria
- At start only Carr's hex is visible.
- Each step reveals the entered hex; revealed hexes stay revealed.
- Changing `reveal_radius` to 1 reveals the ring around Carr too.

## Out of scope
Ink cost, trail, rivers, textures.
