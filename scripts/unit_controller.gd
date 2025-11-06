# Unit.gd - Save this as a separate script file
class_name Unit
extends Node2D

var team: String = "RED"
var hex_position: Vector2i
var unit_size: float = 32.0
var is_selected: bool = false

# Movement properties
var max_movement: int = 2
var current_movement: int = 2  # Remaining movement this turn

func _ready():
	queue_redraw()

func _draw():
	var color = Color.RED if team == "RED" else Color.BLUE
	var border_color = Color.WHITE
	
	# Draw filled square
	var rect = Rect2(-unit_size/2, -unit_size/2, unit_size, unit_size)
	draw_rect(rect, color)
	
	# Draw border (thicker and yellow if selected)
	if is_selected:
		draw_rect(rect, Color.YELLOW, false, 4.0)
	else:
		draw_rect(rect, border_color, false, 2.0)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# Get the global mouse position and convert to local coordinates
			var global_mouse = get_global_mouse_position()
			var local_pos = to_local(global_mouse)
			var rect = Rect2(-unit_size/2, -unit_size/2, unit_size, unit_size)
			if rect.has_point(local_pos):
				get_parent().on_unit_clicked(self)
				print("Unit: ", name, " | Team: ", team, " | Hex Position: ", hex_position, " | Movement: ", current_movement, "/", max_movement)
				get_viewport().set_input_as_handled()

func set_hex_position(hex_pos: Vector2i):
	hex_position = hex_pos

func set_team(team_name: String):
	team = team_name
	queue_redraw()

func set_selected(selected: bool):
	is_selected = selected
	queue_redraw()

func select():
	set_selected(true)

func deselect():
	set_selected(false)

func can_move() -> bool:
	"""Check if unit has movement remaining"""
	return current_movement > 0

func use_movement():
	"""Consume all movement for this turn"""
	current_movement = 0
	print(name, " used movement. Remaining: ", current_movement)

func reset_movement():
	"""Reset movement at the start of a new turn"""
	current_movement = max_movement
	print(name, " movement reset to ", current_movement)

func set_max_movement(new_max: int):
	"""Set the maximum movement range for this unit"""
	max_movement = new_max
	current_movement = max_movement
