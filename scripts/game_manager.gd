# GameManager.gd - Attach this to a Node2D in your main scene
extends Node2D

@export var tilemap: TileMapLayer

var units: Array = []

func _ready():
	if not tilemap:
		push_error("TileMapLayer not assigned to GameManager!")
		return
	
	spawn_initial_units()

func spawn_initial_units():
	# Spawn RED team units
	spawn_unit(Vector2i(2, 2), "RED", "Red_Unit_1")
	spawn_unit(Vector2i(3, 2), "RED", "Red_Unit_2")
	
	# Spawn BLUE team units
	spawn_unit(Vector2i(7, 5), "BLUE", "Blue_Unit_1")
	spawn_unit(Vector2i(8, 5), "BLUE", "Blue_Unit_2")

func spawn_unit(hex_pos: Vector2i, team: String, unit_name: String):
	var unit = UnitNode.new()
	unit.name = unit_name
	unit.team = team
	unit.hex_position = hex_pos
	unit.game_manager = self
	
	# Convert hex position to world position
	var world_pos = tilemap.map_to_local(hex_pos)
	unit.position = world_pos
	
	add_child(unit)
	units.append(unit)
	
	print("Spawned ", unit_name, " at hex ", hex_pos)

# Inner class for units
class UnitNode extends Node2D:
	var team: String = "RED"
	var hex_position: Vector2i
	var unit_size: float = 32.0
	var game_manager: Node = null
	
	func _ready():
		queue_redraw()
	
	func _draw():
		var color = Color.RED if team == "RED" else Color.BLUE
		var border_color = Color.WHITE
		
		# Draw filled square
		var rect = Rect2(-unit_size/2, -unit_size/2, unit_size, unit_size)
		draw_rect(rect, color)
		draw_rect(rect, border_color, false, 2.0)
	
	func _input(event):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				var global_mouse = get_global_mouse_position()
				var local_pos = to_local(global_mouse)
				var rect = Rect2(-unit_size/2, -unit_size/2, unit_size, unit_size)
				if rect.has_point(local_pos):
					print("Unit: ", name, " | Team: ", team, " | Hex Position: ", hex_position)
					get_viewport().set_input_as_handled()
