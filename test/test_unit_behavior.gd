extends GdUnitTestSuite

var runner: GdUnitSceneRunner
var game_manager: Node2D
var tilemap: TileMapLayer

func before_test():
	# Load and run the actual game scene
	runner = scene_runner("res://scenes/game_manager.tscn")
	game_manager = runner.scene()
	tilemap = game_manager.get_node("TileMapLayer")
	
	# Wait for scene to be ready
	#await runner.await_scene_ready()

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
	await runner.simulate_mouse_move_absolute(screen_pos)
	await runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_input_processed()

## Test: Clicking on a unit selects it
func test_click_unit_selects():
	# Get one of the spawned units
	var units = game_manager.units
	assert_int(units.size()).is_greater(0)
	
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
	pass

## Test: Clicking empty space has no effect
func test_click_empty_space_ignored():
	pass

## Test: Right click does nothing (only left click is handled)
func test_right_click_ignored():
	pass

## Test: Unit can move to adjacent hex
func test_unit_moves_to_adjacent_hex():
	pass

## Test: Clicking different unit changes selection
func test_click_different_unit_moves_to_unit():
	pass

## Test: Unit can moves 2 hexes away
func test_unit_moves_two_hexes_away():
	pass

## Test: Unit cannnot move beyond max movement range
func test_unit_moves_too_far_ignored():
	pass

## Test: Unit can move multiple times within max range
func test_unit_moves_more_than_once():
	pass
