# CameraController.gd - Attach this to a Camera2D node
extends Camera2D

# Pan settings
@export var pan_speed: float = 500.0

# Zoom settings
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0

func _ready():
	# Set initial zoom
	zoom = Vector2(1.0, 1.0)

func _process(delta):
	handle_panning(delta)

func _input(event):
	handle_zoom(event)

func handle_panning(delta):
	var direction = Vector2.ZERO
	
	# WASD controls
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1
	
	# Normalize diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Move camera (adjust for zoom level so it feels consistent)
	position += direction * pan_speed * delta / zoom.x

func handle_zoom(event):
	if event is InputEventMouseButton:
		var zoom_change = Vector2.ZERO
		
		# Zoom in with mouse wheel up
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			zoom_change = Vector2(zoom_speed, zoom_speed)
		
		# Zoom out with mouse wheel down
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			zoom_change = Vector2(-zoom_speed, -zoom_speed)
		
		# Apply zoom with clamping
		if zoom_change != Vector2.ZERO:
			var new_zoom = zoom + zoom_change
			new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
			new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
			zoom = new_zoom
