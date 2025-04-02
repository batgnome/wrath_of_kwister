extends Node3D

@export var sensitivity := 0.005
@export var pivot_path : NodePath  # Drag in the CameraPivot here
@export var vertical_min := deg_to_rad(-30)
@export var vertical_max := deg_to_rad(45)

var yaw := 0.0
var pitch := 0.0
var pivot : Node3D

func _ready():
	pivot = get_node(pivot_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, vertical_min, vertical_max)
		
		rotation.y = yaw
		rotation.x = pitch
		#pivot.rotation.x = pitch
		
func _input(event):
	if event.is_action_pressed("stop"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("escape"):
		get_tree().quit()
