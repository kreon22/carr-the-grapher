# 002 — Carr moves hex to hex

Status: done
Depends on: 001

## Goal
Carr exists on the map and can walk one hex at a time.

## Scope
- `scenes/carr.tscn` + `scripts/carr.gd`: a simple marker (a circle or ink dot is fine) at a hex position.
- Keyboard movement to the 6 neighbors. Pointy-top hexes have 6 directions, so propose a key scheme (e.g. Q/W/E/A/S/D) and note it in `docs/decisions.md`.
- Short tween between hexes so the move feels deliberate, not instant. Input ignored while moving.
- Can't move off the map.
- Emits `signal moved(from: Vector2i, to: Vector2i)` — other systems will listen to this.

## Acceptance criteria
- Carr starts at (0, 0) and can reach any hex on the map.
- Pressing toward the map edge does nothing.
- The `moved` signal fires once per step (verify with a print or test).

## Out of scope
Fog, ink cost, trail, rivers.
