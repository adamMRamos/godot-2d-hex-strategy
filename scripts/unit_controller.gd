# Unit.gd - Save this as a separate script file
class_name Unit
extends Node2D

var team: String = "RED"
var hex_position: Vector2i
var unit_size: float = 32.0

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
			# Get the global mouse position and convert to local coordinates
			var global_mouse = get_global_mouse_position()
			var local_pos = to_local(global_mouse)
			var rect = Rect2(-unit_size/2, -unit_size/2, unit_size, unit_size)
			if rect.has_point(local_pos):
				print("Unit: ", name, " | Team: ", team, " | Hex Position: ", hex_position)
				get_viewport().set_input_as_handled()

func set_hex_position(hex_pos: Vector2i):
	hex_position = hex_pos

func set_team(team_name: String):
	team = team_name
	queue_redraw()  # Redraw with new color
