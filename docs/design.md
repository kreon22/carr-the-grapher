# Carr the Grapher — Design Bible

*Living document. Owned by the design side (chat). Code reads it, doesn't edit it.*

## One-liner
A tactile, meditative exploration game: you are Carr, a cartographer, and the map you draw with limited ink *is* the game.

## Genre & feel
- Tactile indie exploration & cartography prototype.
- Aesthetic: hand-drawn ink on antique vellum. Moody, meditative — but with high-stakes logistics underneath (every stroke costs ink).

## Pillars
1. **Hexagonal world.** The world is a hex grid in axial coordinates (q, r). Rivers and landmarks sit at hex **centers**.
2. **Tactile cartography.** Movement leaves a persistent ink trace — shaky, hand-drawn strokes, never clean vector lines.
3. **Fog of vellum.** Unexplored hexes are covered by dark, textured parchment. Visiting a hex reveals it.
4. **Ink is a resource.** Moving consumes ink. Running low creates tension and forces choices about where to go.
5. **Narrative agency.** Reaching a landmark (e.g. the River Valley) triggers a choice that redefines the map and affects faction states.

## Open questions
- What happens when ink runs out? (Game over? Can't move? Can only move without drawing?)
- How is ink replenished?
- What are the factions, and what do they want from the map?
- Is the map *shown* to anyone? (Patrons, guilds — who is Carr drawing for?)

## Mechanics (current understanding)
- **Movement:** step-by-step, one hex at a time, keyboard.
- **Ink cost:** per move (amount TBD; tune in play).
- **River Valley:** special hex type. First entry recolors the ink trail watery blue (#5dade2) and fires a discovery.
