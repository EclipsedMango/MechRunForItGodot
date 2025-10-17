extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@export var foward_input = "w"
@export var left_input = "a"
@export var back_input = "s"
@export var right_input = "d"
@export var jump_input = "space"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if position.y < -5.0:
		position = Vector3(0.0, 1.0, 0.0)
	
	if Input.is_action_just_pressed(jump_input) && is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(left_input, right_input, foward_input, back_input)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	

	move_and_slide()
