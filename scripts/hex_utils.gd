class_name HexUtils
# https://www.redblobgames.com/grids/hexagons/#range
# https://www.redblobgames.com/grids/hexagons/#range-obstacles
# hex map is using ODD-r offset coords
# see: https://www.redblobgames.com/grids/hexagons/#coordinates-offset

# Convert offset coordinates (used by Godot TileMap) to axial coordinates
# For pointy-top hexes with odd-r horizontal layout
static func offset_to_axial(offset_coords: Vector2i) -> Vector2i:
	var col = offset_coords.x
	var row = offset_coords.y
	var q = col - (row - (row & 1)) / 2
	var r = row
	return Vector2i(q, r)

# Convert axial to cube coordinates (needed for distance calculation)
static func axial_to_cube(axial_coords: Vector2i) -> Vector3i:
	var q = axial_coords.x
	var r = axial_coords.y
	var s = -q - r
	return Vector3i(q, r, s)

# Calculate hex distance between two offset coordinates
static func hex_distance(offset_a: Vector2i, offset_b: Vector2i) -> int:
	# Convert to axial
	var axial_a = offset_to_axial(offset_a)
	var axial_b = offset_to_axial(offset_b)
	
	# Convert to cube
	var cube_a = axial_to_cube(axial_a)
	var cube_b = axial_to_cube(axial_b)
	
	# Calculate distance using cube coordinates
	var dx = abs(cube_a.x - cube_b.x)
	var dy = abs(cube_a.y - cube_b.y)
	var dz = abs(cube_a.z - cube_b.z)
	
	return (dx + dy + dz) / 2
