class_name Hex
extends RefCounted
## Axial hex math for pointy-top hexes. All hex math lives here, nowhere else.
## A hex is a Vector2i(q, r); the implicit cube coordinate is s = -q - r.

const SQRT3: float = 1.7320508075688772

## Pointy-top directions, clockwise from east (screen y points down).
## Values index into DIRECTIONS.
enum Dir { E, SE, SW, W, NW, NE }

## The six axial neighbor offsets, in Dir order.
const DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 1),
	Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, -1),
]


## Center of hex `q_r` in local pixels, with (0, 0) at the origin.
static func to_world(q_r: Vector2i, size: float) -> Vector2:
	var x: float = size * (SQRT3 * q_r.x + SQRT3 / 2.0 * q_r.y)
	var y: float = size * (1.5 * q_r.y)
	return Vector2(x, y)


## Hex containing local pixel position `pos`.
static func from_world(pos: Vector2, size: float) -> Vector2i:
	var q: float = (SQRT3 / 3.0 * pos.x - pos.y / 3.0) / size
	var r: float = (2.0 / 3.0 * pos.y) / size
	return cube_round(q, r)


## Rounds fractional axial coordinates to the nearest hex, keeping q + r + s = 0.
static func cube_round(q: float, r: float) -> Vector2i:
	var s: float = -q - r
	var rq: float = roundf(q)
	var rr: float = roundf(r)
	var rs: float = roundf(s)
	var dq: float = absf(rq - q)
	var dr: float = absf(rr - r)
	var ds: float = absf(rs - s)
	if dq > dr and dq > ds:
		rq = -rr - rs
	elif dr > ds:
		rr = -rq - rs
	return Vector2i(int(rq), int(rr))


## The hex one step from `q_r` in direction `dir` (a Dir value).
static func neighbor(q_r: Vector2i, dir: Dir) -> Vector2i:
	return q_r + DIRECTIONS[dir]


static func neighbors(q_r: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for d: Vector2i in DIRECTIONS:
		result.append(q_r + d)
	return result


## Number of steps between two hexes.
static func distance(a: Vector2i, b: Vector2i) -> int:
	var d: Vector2i = a - b
	@warning_ignore("integer_division")
	return (absi(d.x) + absi(d.y) + absi(d.x + d.y)) / 2


## All hexes within `radius` steps of `center`, center included.
static func in_radius(center: Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for q: int in range(-radius, radius + 1):
		for r: int in range(maxi(-radius, -q - radius), mini(radius, -q + radius) + 1):
			result.append(center + Vector2i(q, r))
	return result


## The six corner points of a pointy-top hex centered at `center`.
static func corners(center: Vector2, size: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i: int in 6:
		var angle: float = deg_to_rad(60.0 * i - 30.0)
		points.append(center + Vector2(cos(angle), sin(angle)) * size)
	return points
