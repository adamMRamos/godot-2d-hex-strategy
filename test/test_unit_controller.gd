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

## Test: set_selected updates the is_selected flag
func test_set_selected():
	unit.set_selected(true)
	assert_bool(unit.is_selected).is_true()
	
	unit.set_selected(false)
	assert_bool(unit.is_selected).is_false()

## Test: select() sets is_selected to true
func test_select():
	unit.is_selected = false
	unit.select()
	assert_bool(unit.is_selected).is_true()

## Test: deselect() sets is_selected to false
func test_deselect():
	unit.is_selected = true
	unit.deselect()
	assert_bool(unit.is_selected).is_false()

## Test: can_move returns true when unit has movement
func test_can_move_with_movement():
	unit.current_movement = 2
	assert_bool(unit.can_move()).is_true()

## Test: can_move returns false when current_movement is 0
func test_can_move_no_movement():
	unit.current_movement = 0
	assert_bool(unit.can_move()).is_false()

## Test: can_move returns false when current_movement is 0
func test_can_move_negative_movement():
	unit.current_movement = -1
	assert_bool(unit.can_move()).is_false()
	
