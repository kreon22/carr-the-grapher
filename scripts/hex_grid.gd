class_name HexGrid
extends Node2D
## A hex-shaped map of the given radius, drawn as ink outlines on parchment.
## Highlights the hex under the mouse.

signal hovered_changed(q_r: Vector2i, inside: bool)

@export var radius: int = 6
@export var hex_size: float = 28.0
@export var line_width: float = 2.0
@export var parchment_color: Color = Color("#e8d9b5")
@export var ink_color: Color = Color("#4a3222")
@export var hover_color: Color = Color(0.29, 0.196, 0.133, 0.2)

var cells: Dictionary[Vector2i, bool] = {}
var hovered: Vector2i = Vector2i.ZERO
var has_hover: bool = false


func _ready() -> void:
	RenderingServer.set_default_clear_color(parchment_color)
	for q_r: Vector2i in Hex.in_radius(Vector2i.ZERO, radius):
		cells[q_r] = true


func has_cell(q_r: Vector2i) -> bool:
	return cells.has(q_r)


func _process(_delta: float) -> void:
	update_hover(get_local_mouse_position())


## Sets the hovered hex from a local position; redraws only when it changes.
func update_hover(local_pos: Vector2) -> void:
	var q_r: Vector2i = Hex.from_world(local_pos, hex_size)
	var inside: bool = has_cell(q_r)
	if inside == has_hover and (q_r == hovered or not inside):
		return
	hovered = q_r
	has_hover = inside
	hovered_changed.emit(q_r, inside)
	queue_redraw()


func _draw() -> void:
	if has_hover:
		draw_colored_polygon(Hex.corners(Hex.to_world(hovered, hex_size), hex_size), hover_color)
	for q_r: Vector2i in cells:
		var points: PackedVector2Array = Hex.corners(Hex.to_world(q_r, hex_size), hex_size)
		points.append(points[0])
		draw_polyline(points, ink_color, line_width, true)
