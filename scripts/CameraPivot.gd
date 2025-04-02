extends Node3D

@export var follow_speed := 5.0
@export var target_path : NodePath
var target = null

func _ready():
	if target_path != null:
		target = get_node(target_path)

func _process(delta):
	if target:
		global_transform.origin = global_transform.origin.lerp(target.global_transform.origin, follow_speed * delta)
		if target and target.direction.length() > 0.1:
			var desired_rot = atan2(-target.direction.x, -target.direction.z)
			rotation.y = lerp_angle(rotation.y, desired_rot, delta * 2.0)
			
