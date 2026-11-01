class_name Carr
extends Node2D
## Carr's marker on the map. Walks one hex per key press, with a short tween.
## Input is ignored while a step is in progress; steps off the map do nothing.

## Fires once per step, when Carr arrives in the new hex.
signal moved(from: Vector2i, to: Vector2i)

## Input action -> direction. Keys are set in Project Settings > Input Map.
const MOVE_ACTIONS: Dictionary[StringName, Hex.Dir] = {
	&"move_e": Hex.Dir.E,
	&"move_se": Hex.Dir.SE,
	&"move_sw": Hex.Dir.SW,
	&"move_w": Hex.Dir.W,
	&"move_nw": Hex.Dir.NW,
	&"move_ne": Hex.Dir.NE,
}

@export var grid: HexGrid
@export var start: Vector2i = Vector2i.ZERO
@export var step_time: float = 0.25
## Marker radius as a fraction of the hex size.
@export var marker_ratio: float = 0.3
@export var marker_color: Color = Color("#2b1a10")

var coords: Vector2i = Vector2i.ZERO
var is_moving: bool = false


func _ready() -> void:
	coords = start
	global_position = _world_pos(coords)


func _unhandled_input(event: InputEvent) -> void:
	for action: StringName in MOVE_ACTIONS:
		if event.is_action_pressed(action):
			get_viewport().set_input_as_handled()
			try_step(MOVE_ACTIONS[action])
			return


## Starts a step in `dir`. Returns false if busy or the target is off the map.
func try_step(dir: Hex.Dir) -> bool:
	if is_moving:
		return false
	var target: Vector2i = Hex.neighbor(coords, dir)
	if not grid.has_cell(target):
		return false
	var from: Vector2i = coords
	coords = target
	is_moving = true
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", _world_pos(target), step_time)
	tween.finished.connect(_on_step_finished.bind(from, target))
	return true


func _on_step_finished(from: Vector2i, to: Vector2i) -> void:
	is_moving = false
	moved.emit(from, to)


func _world_pos(q_r: Vector2i) -> Vector2:
	return grid.to_global(Hex.to_world(q_r, grid.hex_size))


func _draw() -> void:
	draw_circle(Vector2.ZERO, grid.hex_size * marker_ratio, marker_color, true, -1.0, true)
