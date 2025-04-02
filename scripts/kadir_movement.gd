extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $"../CameraPivot/CameraBoom/Camera3d" # Adjust path if needed
var direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	direction = Vector3.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction.length() > 0.1:
		#look_at(global_transform.origin -direction, Vector3.UP)


	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if direction.length() > 0.1:
		var flat_dir = direction
		flat_dir.y = 0
		flat_dir = flat_dir.normalized()

		var target_rot = atan2(-flat_dir.x, -flat_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rot, 10 * delta)
