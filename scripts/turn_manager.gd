# scripts/turn_manager.gd
extends Node
class_name TurnManager

signal turn_changed(new_team: String)

var current_team: String = "RED"

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter key
		end_turn()

func end_turn():
	current_team = "BLUE" if current_team == "RED" else "RED"
	emit_signal("turn_changed", current_team)
	print(current_team, "'s turn")
