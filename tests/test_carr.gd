extends SceneTree
## Carr movement tests. Run: godot --headless --path . -s tests/test_carr.gd
## Exits with code 1 if any check fails.

const KEYS: Dictionary[Key, Hex.Dir] = {
	KEY_W: Hex.Dir.NW, KEY_E: Hex.Dir.NE,
	KEY_A: Hex.Dir.W, KEY_D: Hex.Dir.E,
	KEY_Z: Hex.Dir.SW, KEY_X: Hex.Dir.SE,
}

var failures: int = 0
var carr: Carr
var grid: HexGrid
var steps: Array[Array] = []


func _init() -> void:
	var main: Node = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	grid = main.get_node("HexGrid")
	carr = main.get_node("Carr")
	carr.step_time = 0.01
	carr.moved.connect(func(from: Vector2i, to: Vector2i) -> void: steps.append([from, to]))
	await process_frame

	await _test_start()
	await _test_keys()
	await _test_busy()
	await _test_edges()
	await _test_reach_all()

	if failures == 0:
		print("test_carr: all passed")
	else:
		printerr("test_carr: %d failed" % failures)
	quit(1 if failures > 0 else 0)


func check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		printerr("FAIL: " + msg)


func _settle() -> void:
	while carr.is_moving:
		await process_frame


func _step(dir: Hex.Dir) -> bool:
	var ok: bool = carr.try_step(dir)
	await _settle()
	return ok


func _go_to(target: Vector2i) -> void:
	while carr.coords != target:
		var best: Hex.Dir = Hex.Dir.E
		for dir: Hex.Dir in Hex.Dir.values():
			if Hex.distance(Hex.neighbor(carr.coords, dir), target) < Hex.distance(Hex.neighbor(carr.coords, best), target):
				best = dir
		if not await _step(best):
			check(false, "blocked walking %s -> %s" % [carr.coords, target])
			return


func _test_start() -> void:
	check(carr.coords == Vector2i.ZERO, "starts at (0, 0)")
	check(carr.global_position.is_equal_approx(grid.to_global(Vector2.ZERO)), "drawn at the center hex")


## Each key moves one hex in its direction, through the real input map.
func _test_keys() -> void:
	for key: Key in KEYS:
		steps.clear()
		var press := InputEventKey.new()
		press.physical_keycode = key
		press.pressed = true
		root.push_input(press)
		var release: InputEventKey = press.duplicate()
		release.pressed = false
		root.push_input(release)
		await process_frame
		await _settle()
		var want: Vector2i = Hex.neighbor(Vector2i.ZERO, KEYS[key])
		check(carr.coords == want, "%s moves to %s, got %s" % [OS.get_keycode_string(key), want, carr.coords])
		check(steps.size() == 1, "%s fires moved once, got %d" % [OS.get_keycode_string(key), steps.size()])
		await _go_to(Vector2i.ZERO)


## A second step while moving is ignored; moved fires once on arrival.
func _test_busy() -> void:
	steps.clear()
	check(carr.try_step(Hex.Dir.E), "first step starts")
	check(not carr.try_step(Hex.Dir.E), "second step ignored while moving")
	check(steps.is_empty(), "moved not fired before arrival")
	await _settle()
	check(steps == [[Vector2i.ZERO, Vector2i(1, 0)]], "moved fired once with from/to, got %s" % [steps])
	await _go_to(Vector2i.ZERO)


## At each corner of the map, the three outward steps do nothing.
func _test_edges() -> void:
	for dir: Hex.Dir in Hex.Dir.values():
		var corner: Vector2i = Hex.DIRECTIONS[dir] * grid.radius
		await _go_to(corner)
		steps.clear()
		for out: Hex.Dir in [(dir + 5) % 6, dir, (dir + 1) % 6]:
			check(not await _step(out), "step %s off corner %s refused" % [out, corner])
		check(carr.coords == corner, "still at corner %s" % corner)
		check(steps.is_empty(), "no moved signal at corner %s" % corner)
	await _go_to(Vector2i.ZERO)


## Every hex on the map is reachable, one adjacent step at a time.
func _test_reach_all() -> void:
	steps.clear()
	var taken: int = 0
	for q_r: Vector2i in Hex.in_radius(Vector2i.ZERO, grid.radius):
		var before: int = Hex.distance(carr.coords, q_r)
		await _go_to(q_r)
		taken += before
		check(carr.coords == q_r, "reached %s" % q_r)
	check(steps.size() == taken, "one moved per step: %d signals, %d steps" % [steps.size(), taken])
	for s: Array in steps:
		check(Hex.distance(s[0], s[1]) == 1 and grid.has_cell(s[1]), "step %s -> %s is one hex, on the map" % [s[0], s[1]])
