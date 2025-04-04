extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $"../CameraPivot/CameraBoom/Camera3d" # Adjust path if needed
var direction = Vector3.ZERO
@onready var animation_tree = $kadir/AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var RUNSPEED = 10.0
var run_tog = false


func _ready():
	animation_tree.active = true

func _physics_process(delta):
	var current_speed = SPEED
	if Input.is_action_just_pressed("shift"):
		run_tog = !run_tog
	if run_tog:
		current_speed = RUNSPEED
	else:
		current_speed = SPEED

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction.length() > 0.1:
		#look_at(global_transform.origin -direction, Vector3.UP)


	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	if abs(direction.length())  > 0.1:
		var flat_dir = direction
		flat_dir.y = 0
		flat_dir = flat_dir.normalized()

		var target_rot = atan2(-flat_dir.x, -flat_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rot, 10 * delta)
	var moving = velocity.length_squared() > 0.01
	
	var grounded = is_on_floor()
	animation_tree.set("parameters/MoveBlend/blend_position", abs(direction.length()))
	
	if is_on_floor():
		var blend_value = abs(direction.length()) * (1.0 if run_tog else 0.5)
		animation_tree.set("parameters/MoveBlend/blend_position", blend_value)
	
		
	#if grounded:
		#if moving:
			#if run_tog:
				#state_machine.travel("run")
			#else:
				#state_machine.travel("walk")  # Use exact names
		#else:
			#state_machine.travel("idle")
	#else:
		#state_machine.travel("jump")
	direction = Vector3.ZERO
