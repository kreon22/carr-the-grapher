class_name Fog
extends Node2D
## Fog of vellum: covers every hex Carr hasn't visited with dark parchment.
## Owns the set of revealed hexes. Listens to Carr's `moved`; reveals on arrival.

@export var grid: HexGrid
@export var carr: Carr
## How far around Carr each visit reveals. 0 = only the hex itself, 1 = plus its ring.
@export var reveal_radius: int = 0
@export var fog_color: Color = Color("#3a2b1f")
## Fog hexes are drawn slightly oversized so neighbors overlap without seams.
@export var overlap: float = 1.03

var revealed: Dictionary[Vector2i, bool] = {}


func _ready() -> void:
	carr.moved.connect(_on_carr_moved)
	if not carr.is_node_ready():
		await carr.ready
	reveal_around(carr.coords)


func is_revealed(q_r: Vector2i) -> bool:
	return revealed.has(q_r)


## Reveals every map hex within `reveal_radius` of `center`.
func reveal_around(center: Vector2i) -> void:
	for q_r: Vector2i in Hex.in_radius(center, reveal_radius):
		if grid.has_cell(q_r):
			revealed[q_r] = true
	queue_redraw()


func _on_carr_moved(_from: Vector2i, to: Vector2i) -> void:
	reveal_around(to)


func _draw() -> void:
	for q_r: Vector2i in grid.cells:
		if not revealed.has(q_r):
			var center: Vector2 = to_local(grid.to_global(Hex.to_world(q_r, grid.hex_size)))
			draw_colored_polygon(Hex.corners(center, grid.hex_size * overlap), fog_color)
