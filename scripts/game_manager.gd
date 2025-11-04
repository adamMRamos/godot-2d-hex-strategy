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
