extends GdUnitTestSuite

## Test: Distance from hex to itself should be 0
func test_hex_distance_same_hex():
	assert_int(HexUtils.hex_distance(Vector2i(0, 0), Vector2i(0, 0))).is_equal(0)
	assert_int(HexUtils.hex_distance(Vector2i(5, 5), Vector2i(5, 5))).is_equal(0)
	assert_int(HexUtils.hex_distance(Vector2i(10, 10), Vector2i(10, 10))).is_equal(0)
