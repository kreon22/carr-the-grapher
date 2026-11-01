extends SceneTree
## Fog of vellum tests. Run: godot --headless --path . -s tests/test_fog.gd
## Exits with code 1 if any check fails.

var failures: int = 0
var main: Node
var fog: Fog
var carr: Carr


func _init() -> void:
	await _test_radius_0()
	await _test_radius_1()
	await _test_other_start()
	if failures == 0:
		print("test_fog: all passed")
	else:
		printerr("test_fog: %d failed" % failures)
	quit(1 if failures > 0 else 0)


func check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		printerr("FAIL: " + msg)


## Fresh main scene with the given fog radius and Carr start.
func _load(reveal_radius: int, start: Vector2i = Vector2i.ZERO) -> void:
	if main:
		main.free()
	main = load("res://scenes/main.tscn").instantiate()
	fog = main.get_node("Fog")
	carr = main.get_node("Carr")
	fog.reveal_radius = reveal_radius
	carr.start = start
	carr.step_time = 0.01
	root.add_child(main)
	await process_frame


func _step(dir: Hex.Dir) -> void:
	carr.try_step(dir)
	while carr.is_moving:
		await process_frame


func _revealed() -> Array[Vector2i]:
	var keys: Array[Vector2i] = fog.revealed.keys()
	keys.sort()
	return keys


func _sorted(cells: Array[Vector2i]) -> Array[Vector2i]:
	var copy: Array[Vector2i] = cells.duplicate()
	copy.sort()
	return copy


func _test_radius_0() -> void:
	await _load(0)
	check(_revealed() == [Vector2i.ZERO], "radius 0: only start revealed, got %s" % [_revealed()])

	carr.try_step(Hex.Dir.E)
	check(not fog.is_revealed(Vector2i(1, 0)), "radius 0: target not revealed before arrival")
	while carr.is_moving:
		await process_frame
	check(fog.is_revealed(Vector2i(1, 0)), "radius 0: entered hex revealed")

	await _step(Hex.Dir.NE)
	await _step(Hex.Dir.NW)
	await _step(Hex.Dir.W)
	var path: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, -1), Vector2i(2, -2), Vector2i(1, -2)]
	check(_revealed() == _sorted(path), "radius 0: exactly the path stays revealed, got %s" % [_revealed()])


func _test_radius_1() -> void:
	await _load(1)
	check(_revealed() == _sorted(Hex.in_radius(Vector2i.ZERO, 1)), "radius 1: start and its ring revealed, got %s" % [_revealed()])

	await _step(Hex.Dir.E)
	var want: Dictionary[Vector2i, bool] = {}
	for q_r: Vector2i in Hex.in_radius(Vector2i.ZERO, 1) + Hex.in_radius(Vector2i(1, 0), 1):
		want[q_r] = true
	check(_revealed() == _sorted(want.keys()), "radius 1: ring around new hex added, got %s" % [_revealed()])

	for i: int in 5:
		await _step(Hex.Dir.E)
	check(carr.coords == Vector2i(6, 0), "radius 1: walked to the map edge")
	for q_r: Vector2i in fog.revealed:
		check(fog.grid.has_cell(q_r), "radius 1: revealed %s is on the map" % q_r)
	check(fog.is_revealed(Vector2i(5, 1)) and fog.is_revealed(Vector2i(6, -1)), "radius 1: on-map ring at edge revealed")


func _test_other_start() -> void:
	await _load(0, Vector2i(2, -1))
	check(_revealed() == [Vector2i(2, -1)], "starts revealed wherever Carr starts, got %s" % [_revealed()])
