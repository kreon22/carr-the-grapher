extends SceneTree
## Hex math tests. Run: godot --headless --path . -s tests/test_hex.gd
## Exits with code 1 if any check fails.

const SIZE: float = 28.0

var failures: int = 0


func _init() -> void:
	_test_round_trip()
	_test_edges()
	_test_distance()
	_test_neighbors()
	_test_in_radius()
	if failures == 0:
		print("test_hex: all passed")
	else:
		printerr("test_hex: %d failed" % failures)
	quit(1 if failures > 0 else 0)


func check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		printerr("FAIL: " + msg)


func _test_round_trip() -> void:
	for q_r: Vector2i in Hex.in_radius(Vector2i.ZERO, 10):
		var back: Vector2i = Hex.from_world(Hex.to_world(q_r, SIZE), SIZE)
		check(back == q_r, "round trip %s -> %s" % [q_r, back])


## Points just inside each corner and edge belong to the hex;
## points just past an edge midpoint belong to the neighbor across it.
func _test_edges() -> void:
	for q_r: Vector2i in Hex.in_radius(Vector2i.ZERO, 5):
		var center: Vector2 = Hex.to_world(q_r, SIZE)
		var pts: PackedVector2Array = Hex.corners(center, SIZE)
		for i: int in 6:
			var corner: Vector2 = pts[i]
			var mid: Vector2 = (pts[i] + pts[(i + 1) % 6]) / 2.0
			check(Hex.from_world(center.lerp(corner, 0.97), SIZE) == q_r, "near corner %d of %s" % [i, q_r])
			check(Hex.from_world(center.lerp(mid, 0.99), SIZE) == q_r, "inside edge %d of %s" % [i, q_r])
			var across: Vector2i = Hex.from_world(center.lerp(mid, 1.01), SIZE)
			check(Hex.distance(across, q_r) == 1, "past edge %d of %s lands on a neighbor" % [i, q_r])
			check(Hex.from_world(center.lerp(mid, 2.0), SIZE) == across, "neighbor across edge %d of %s" % [i, q_r])


func _test_distance() -> void:
	check(Hex.distance(Vector2i.ZERO, Vector2i.ZERO) == 0, "distance to self")
	check(Hex.distance(Vector2i(0, 0), Vector2i(3, -1)) == 3, "distance (0,0)-(3,-1)")
	check(Hex.distance(Vector2i(2, 3), Vector2i(-1, 1)) == 5, "distance (2,3)-(-1,1)")
	check(Hex.distance(Vector2i(-4, 2), Vector2i(1, -3)) == 5, "distance (-4,2)-(1,-3)")
	check(Hex.distance(Vector2i(1, 2), Vector2i(-2, -1)) == Hex.distance(Vector2i(-2, -1), Vector2i(1, 2)), "distance symmetric")


func _test_neighbors() -> void:
	var n: Array[Vector2i] = Hex.neighbors(Vector2i(2, -1))
	check(n.size() == 6, "six neighbors")
	for q_r: Vector2i in n:
		check(Hex.distance(q_r, Vector2i(2, -1)) == 1, "neighbor %s at distance 1" % q_r)
		var gap: float = Hex.to_world(q_r, SIZE).distance_to(Hex.to_world(Vector2i(2, -1), SIZE))
		check(is_equal_approx(gap, SIZE * Hex.SQRT3), "neighbor %s at one hex width" % q_r)


func _test_in_radius() -> void:
	# A hex map of radius N has 3N(N+1) + 1 cells.
	for r: int in [0, 1, 6]:
		check(Hex.in_radius(Vector2i.ZERO, r).size() == 3 * r * (r + 1) + 1, "cell count radius %d" % r)
	for q_r: Vector2i in Hex.in_radius(Vector2i(1, 1), 3):
		check(Hex.distance(q_r, Vector2i(1, 1)) <= 3, "%s within radius" % q_r)
