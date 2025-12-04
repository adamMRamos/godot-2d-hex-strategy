# GameManager.gd - Attach this to a Node2D in your main scene
extends Node2D

@export var tilemap: TileMapLayer
var turn_manager: TurnManager

var units: Array[Unit] = []
var selected_unit: Unit = null

func _ready():
	if not tilemap:
		push_error("TileMapLayer not assigned to GameManager!")
		return
	
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	turn_manager.turn_changed.connect(_on_turn_changed)
	
	spawn_initial_units()

func _on_turn_changed(new_team: String):
	# Deselect any selected unit when turn changes
	if selected_unit != null:
		selected_unit.deselect()
		selected_unit = null

func _input(event):
	# If user clicks anywhere that wasn't handled by a unit, deselect
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# Get the clicked hex position
			var hex_pos = tilemap.mouse_to_hex()
			
			# If a unit is selected, move it to the clicked hex
			if selected_unit != null:
				get_viewport().set_input_as_handled()
				move_unit_to_hex(selected_unit, hex_pos)
			else:
				# No unit selected, just deselect (clicking empty space)
				print("Clicked empty hex: ", hex_pos)

func spawn_initial_units():
	# Spawn RED team units
	spawn_unit(Vector2i(2, 2), "RED", "Red_Unit_1")
	spawn_unit(Vector2i(3, 2), "RED", "Red_Unit_2")
	
	# Spawn BLUE team units
	spawn_unit(Vector2i(7, 5), "BLUE", "Blue_Unit_1")
	spawn_unit(Vector2i(8, 5), "BLUE", "Blue_Unit_2")

func spawn_unit(hex_pos: Vector2i, team: String, unit_name: String):
	# Create a new Node2D and attach the Unit script
	var unit = Unit.new()
	unit.name = unit_name
	
	# Set unit properties
	unit.set_team(team)
	unit.set_hex_position(hex_pos)
	
	# Convert hex position to world position
	var world_pos = tilemap.map_to_local(hex_pos)
	unit.position = world_pos
	
	add_child(unit)
	units.append(unit)
	
	print("Spawned ", unit_name, " at hex ", hex_pos)

func on_unit_clicked(unit: Unit):
	# Deselect previously selected unit
	if selected_unit != null:
		selected_unit.deselect()
	
	# Select the new unit
	selected_unit = unit
	selected_unit.select()
	
	print("Selected Unit: ", unit.name, " | Team: ", unit.team, " | Hex Position: ", unit.hex_position)

func move_unit_to_hex(unit: Unit, hex_pos: Vector2i):
	# find hex distance
	var origin = unit.hex_position
	var distance = HexUtils.hex_distance(origin, hex_pos)
	
	# try to move unit
	if unit.can_move_to(distance) and hex_is_vacant(hex_pos):
		# Update unit's hex position
		unit.set_hex_position(hex_pos)
	
		# Convert hex position to world position
		var world_pos = tilemap.map_to_local(hex_pos)
		unit.position = world_pos
		
		print("Moved ", unit.name, " from ", origin, " to ", hex_pos, " | cost ", distance)
	else:
		print("Can't move ", unit.name, " from ", origin, " to ", hex_pos, " | cost ", distance)
	
	# Deselect the unit after trying to move
	unit.deselect()
	selected_unit = null

func hex_is_vacant(hex_pos: Vector2i) -> bool:
	for unit in units:
		if unit.hex_position == hex_pos:
			return false
	
	return true
