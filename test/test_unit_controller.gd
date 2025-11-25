extends GdUnitTestSuite

var unit: Unit

func before_test():
	# Create a new unit instance before each test
	unit = auto_free(Unit.new())

func after_test():
	# Cleanup happens automatically with auto_free
	unit = null

## Test: set_hex_position updates the hex_position
func test_set_hex_position():
	unit.set_hex_position(Vector2i(5, 5))
	assert_object(unit.hex_position).is_equal(Vector2i(5, 5))
	
	unit.set_hex_position(Vector2i(10, 3))
	assert_object(unit.hex_position).is_equal(Vector2i(10, 3))

## Test: set_team updates the team property
func test_set_team():
	unit.set_team("RED")
	assert_str(unit.team).is_equal("RED")
	
	unit.set_team("BLUE")
	assert_str(unit.team).is_equal("BLUE")
