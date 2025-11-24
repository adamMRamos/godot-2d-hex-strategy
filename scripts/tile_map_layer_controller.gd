extends TileMapLayer

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			print(mouse_to_hex())

func pos_to_hex(global_clicked: Vector2) -> Vector2:
	"""note: the hex map layout is currently odd-r"""
	return local_to_map(to_local(global_clicked))

func mouse_to_hex() -> Vector2:
	return pos_to_hex(get_global_mouse_position())
