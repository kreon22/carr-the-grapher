# Carr the Grapher — Design Bible

*Living document. Owned by the design side (chat). Code reads it, doesn't edit it.*

## One-liner
You are Carr, a cartographer for hire. You go out alone into unmapped country, sketch what you find, and bring your maps home, where the factions read them and act on them. You never quite know what they'll make of your work.

## The loop
1. **Commission:** someone back home sends you out. Map what hasn't been mapped: a lake's depths, a border over a mountain, a coastline.
2. **Expedition:** you're alone (sometimes with an entourage on rough gigs), with wind, nature sounds and the landscape described to you. **Time pressure lives here:** supplies, weather and the season limit how long you can stay out on the track.
3. **Drawing:** no time pressure. Rustling paper, scratching ink. You draw the map *and* landscape sketches, and you place old-map icons (peril markers on a ridge, a ford, a smugglers' cove).
4. **Report:** back in the city, with scene-based music. You decide who sees your maps and what they show. The factions interpret them, and the result is uncertain and fascinating.
5. **Consequences and next commission:** troops move, borders shift, bribes arrive, and your standing changes. A new gig follows.

## What drawing does
- **Builds the atlas.** Every map and landscape sketch joins a growing world map and sketchbook: *your* picture of the world, accumulated over the game.
- **Carries icons.** Old-map conventions mark peril, resources, routes and settlements. Icons are the main way your map says things.
- **Is political.** A map is intel. What you include or leave out, and where you draw a border, decides who knows what, where troops go and whose territory grows. Factions may bribe you to draw a border a bit differently.
- **Moves resources.** Pay, bribes, supplies for the next expedition.

## The core hook: interpretation
Submitting a map should feel like pulling a lever: you hand it over, and you're never sure what comes back.
- Each faction reads your map through its own interests, and may misread it, over-read it, or act on it in ways you didn't intend.
- **Implementation idea:** the stakeholders are played by an AI. Your drawing (as an image) plus your icons and notes go to Claude, which answers in character as each faction. The result is structured game effects plus flavor text.
- Outcomes accumulate into the bigger picture: a world state that remembers what every faction believes, based on *your* maps.

## Mood & presentation
- Hand-drawn ink on antique vellum: moody and meditative.
- **Sound by scene:** wilderness has only nature sounds (wind, water, birds); drawing has paper rustle and pen scratch; the city has music.
- Landscapes are shown as text descriptions and/or ink-style illustrations.

## Commission types (seed list)
- Lake depth survey from a boat (soundings).
- Border survey over a mountain, through rough terrain.
- Rough or dangerous gigs that come with an entourage.
- Mostly: alone, sketching.

## Open questions
- Who are the factions back home (council members? guilds? a crown vs. a merchant house?), and what does each want from maps?
- What exactly limits time on the expedition (food, weather, season, a deadline)?
- How does the "truth" of the land relate to your drawing? Is there a hidden real map your drawing gets compared to?
- Does a mis-drawn map come back to haunt you (someone gets lost, troops walk into peril)?
- How free is drawing: true freehand, icon placement on a base, or both?

## History
- Started as a Godot 4 hex exploration prototype (tasks 001–003 done: hex grid, movement, fog of vellum). Paused 2026-11-10 in favor of a browser MVP of the loop above. See `decisions.md`.
