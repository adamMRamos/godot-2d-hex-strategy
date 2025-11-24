extends GdUnitTestSuite

func test_HexUtils_hex_distance():
	# given an origin and destination, they are the same
	var origin = Vector2i(0, 0)
	var destination = origin
	
	# get the distance between origin and destination
	var distance = HexUtils.hex_distance(origin, destination)
	
	# the result should be 0
	assert_int(distance).is_equal(0)
