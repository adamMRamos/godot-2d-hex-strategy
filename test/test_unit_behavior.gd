extends GdUnitTestSuite

var runner: GdUnitSceneRunner
var game_manager: Node2D
var tilemap: TileMapLayer
var camera: Camera2D
var units: Array[Unit]

func before_test():
	# Load and run the actual game scene
	runner = scene_runner("res://scenes/game_manager.tscn")
	game_manager = runner.scene()
	tilemap = game_manager.get_node("TileMapLayer")
	camera = game_manager.get_node("Camera2D")
	units = game_manager.units

func after_test():
	runner = null

# Helper function to convert world position to screen position
func world_to_screen(world_pos: Vector2) -> Vector2:
	var camera = game_manager.get_node("Camera2D")
	var viewport = game_manager.get_viewport()
	
	if camera:
		# Account for camera position and zoom
		var screen_center = viewport.get_visible_rect().size / 2
		return (world_pos - camera.global_position) * camera.zoom + screen_center
	else:
		# No camera, world pos = screen pos
		return world_pos

# Helper function to click at a world position
func click_at_world_pos(world_pos: Vector2):
	var screen_pos = world_to_screen(world_pos)
	await runner.simulate_mouse_move(screen_pos)
	await runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_input_processed()

## Test: Clicking on a unit selects it
func test_click_unit_selects():
	# Get one of the spawned units
	var unit: Unit = units[0]
	var unit_world_pos = unit.global_position
	
	# Simulate mouse click at unit position
	print("start clicking on ", unit_world_pos, " hex is ", tilemap.pos_to_hex(unit_world_pos), " and actual hex ", unit.hex_position)
	# Click the unit
	await click_at_world_pos(unit_world_pos)
	print("done clicking on ", unit_world_pos, " mouse at ", tilemap.get_global_mouse_position())
	
	# Unit should be selected
	assert_bool(unit.is_selected).is_true()
	assert_object(game_manager.selected_unit).is_equal(unit)

## Test: click same unit twice mvoes unit to same hex and deselects
func test_double_click_same_unit():
	# get a units
	var unit = units[0]
	var current_position = unit.global_position
	# select the unit
	await click_at_world_pos(unit.global_position)
	# verify unit is selected
	assert_bool(unit.is_selected).is_true()
	assert_object(game_manager.selected_unit).is_equal(unit)
	# then click the same unit
	await click_at_world_pos(unit.global_position)
	# verify the unit has not moved and no unit is selected 
	assert_vector(unit.global_position).is_equal(current_position)
	assert_bool(unit.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()

## Test: Clicking empty space has no effect
func test_click_empty_space_ignored():
	# click on 0,0 which is empty
	var empty_space = tilemap.map_to_local(Vector2i.ZERO)
	await click_at_world_pos(empty_space)
	
	# verify no unit is selected
	var selected = false
	for u in units:
		if u.is_selected:
			selected = true
			break
	assert_bool(selected).is_false()
	
	# verify game manager selected is null
	assert_object(game_manager.selected_unit).is_null()

## Test: Unit can move to adjacent hex
func test_unit_moves_to_adjacent_hex():
	# get first unit
	var unit = units[0]
	# select unit
	await click_at_world_pos(unit.global_position)
	# click on neighboring hex
	var neighbor_hex = Vector2i(unit.hex_position.x, unit.hex_position.y + 1)
	var neighbor_pos = tilemap.map_to_local(neighbor_hex)
	await click_at_world_pos(neighbor_pos)
	# verify unit has moved to neighbor no longer selected
	assert_vector(unit.global_position).is_equal(neighbor_pos)
	assert_bool(unit.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()

## Test: clicking different unit moves to unit
func test_unit_cannot_move_onto_occupied_hex():
	# get 2 units
	var A = units[0]
	var B = units[1]
	var origin = A.global_position
	# click A
	await click_at_world_pos(A.global_position)
	# verify A is selected
	assert_bool(A.is_selected).is_true()
	assert_object(game_manager.selected_unit).is_equal(A)
	# then click B
	await click_at_world_pos(B.global_position)
	# verify A.hex == B.hex and no unit is selected 
	assert_vector(A.global_position).is_equal(origin)
	assert_bool(A.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()

## Test: Unit can moves 2 hexes away
func test_unit_moves_two_hexes_away():
	# select a unit
	var unit = units[0]
	await click_at_world_pos(unit.global_position)
	# move to two hexes away
	var destination_hex = Vector2i(unit.hex_position.x + unit.max_movement, unit.hex_position.y)
	var destination_local = tilemap.map_to_local(destination_hex)
	await click_at_world_pos(destination_local)
	# verify unit has moved 2 hexes away
	assert_vector(unit.global_position).is_equal(destination_local)
	assert_bool(unit.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()

## Test: Unit cannnot move beyond max movement range
func test_unit_moves_too_far_ignored():
	# select a unit
	var unit = units[0]
	await click_at_world_pos(unit.global_position)
	# move to ten hexes away
	var destination_hex = Vector2i(unit.hex_position.x + 10, unit.hex_position.y)
	var destination_local = tilemap.map_to_local(destination_hex)
	await click_at_world_pos(destination_local)
	# verify unit has NOT moved
	assert_vector(unit.global_position).is_equal(unit.global_position)
	assert_bool(unit.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()

## Test: Unit can move multiple times within max range
func test_unit_moves_more_than_once():
	# select a unit
	var unit = units[0]
	# move max hexes away 3 times
	# move 1
	var destination_hex = Vector2i(unit.hex_position.x + unit.max_movement, unit.hex_position.y)
	var destination_local = tilemap.map_to_local(destination_hex)
	await click_at_world_pos(unit.position)
	await click_at_world_pos(destination_local)
	camera.position = destination_local
	await await_millis(500)
	# move 2
	destination_hex = Vector2i(unit.hex_position.x + unit.max_movement, unit.hex_position.y)
	destination_local = tilemap.map_to_local(destination_hex)
	await click_at_world_pos(unit.position)
	await click_at_world_pos(destination_local)
	camera.position = destination_local
	await await_millis(500)
	# move 3
	destination_hex = Vector2i(unit.hex_position.x + unit.max_movement, unit.hex_position.y)
	destination_local = tilemap.map_to_local(destination_hex)
	await click_at_world_pos(unit.position)
	await click_at_world_pos(destination_local)
	camera.position = destination_local
	await await_millis(500)
	# verify unit has moved to the final location
	assert_vector(unit.position).is_equal(destination_local)
	assert_bool(unit.is_selected).is_false()
	assert_object(game_manager.selected_unit).is_null()
