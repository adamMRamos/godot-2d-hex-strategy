extends GdUnitTestSuite

## Test: Distance from hex to itself should be 0
func test_hex_distance_same_hex():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 0))).is_equal(0)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 5))).is_equal(0)
	assert_int(HexUtils.hex_distance(Vector2i(10, 10), Vector2i(10, 10))).is_equal(0)

## Test: Adjacent hexes horizontally should be distance 1
func test_hex_distance_adjacent_horizontal():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(1, 0))).is_equal(1)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(6, 5))).is_equal(1)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(4, 5))).is_equal(1)

## Test: Adjacent hexes vertically should be distance 1
func test_hex_distance_adjacent_vertical():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 1))).is_equal(1)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 6))).is_equal(1)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 4))).is_equal(1)

## Test: Hexes 2 steps away horizontally
func test_hex_distance_two_away_horizontal():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(2, 0))).is_equal(2)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(7, 5))).is_equal(2)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(3, 5))).is_equal(2)

## Test: Hexes 2 steps away vertically
func test_hex_distance_two_away_vertical():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 2))).is_equal(2)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 7))).is_equal(2)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 3))).is_equal(2)

## Test: Hexes 3 steps away
func test_hex_distance_three_away():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(3, 0))).is_equal(3)
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 3))).is_equal(3)

## Test: Distance is symmetric (A to B == B to A)
func test_hex_distance_symmetric():
	assert_int(
		HexUtils.hex_distance(Vector2i(2, 3), Vector2i(5, 7))
	).is_equal(
		HexUtils.hex_distance(Vector2i(5, 7), Vector2i(2, 3))
	)
	assert_int(
		HexUtils.hex_distance(Vector2i(0, 0), Vector2i(10, 5))
	).is_equal(
		HexUtils.hex_distance(Vector2i(10, 5), Vector2i(0, 0))
	)

## Test: Negative coordinates work correctly
func test_hex_distance_negative_coords():
	assert_int(HexUtils.hex_distance(Vector2i(-2, -2), Vector2i(-2, -2))).is_equal(0)
	assert_int(HexUtils.hex_distance(Vector2i(-1, 0), Vector2i(1, 0))).is_equal(2)
	assert_int(HexUtils.hex_distance(Vector2i(0, -1), Vector2i(0, 1))).is_equal(2)

## Test: Large distances
func test_hex_distance_large():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(10, 0))).is_equal(10)
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 10))).is_equal(10)
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(5, 5))).is_greater(0)

## Test: Distance matches expected hex ring patterns
func test_hex_distance_ring_pattern():
	var center = Vector2i(5, 5)
	
	# All 6 neighbors should be distance 1
	var neighbors = [
		Vector2i(6, 5), Vector2i(4, 5),  # horizontal
		Vector2i(5, 6), Vector2i(5, 4),  # vertical
		Vector2i(6, 6), Vector2i(6, 4),  # diagonals (odd-r specific for row 5)
	]
	
	for neighbor in neighbors:
		assert_int(HexUtils.hex_distance(center, neighbor)).is_equal(1)

## Test: Triangle inequality holds (distance A->C <= A->B + B->C)
func test_hex_distance_triangle_inequality():
	var a = Vector2i(0, 0)
	var b = Vector2i(2, 1)
	var c = Vector2i(5, 5)
	
	var dist_ac = HexUtils.hex_distance(a, c)
	var dist_ab = HexUtils.hex_distance(a, b)
	var dist_bc = HexUtils.hex_distance(b, c)
	
	assert_int(dist_ac).is_equal(dist_ab + dist_bc)
