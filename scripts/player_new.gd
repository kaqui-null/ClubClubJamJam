extends CharacterBody2D

@export var SPEED: float = 100.0
@export var GRAV_ACC: float = (35 / 1.8) * 9.81

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float) -> void:
	var old_velocity: Vector2 = velocity
	var direction: float = Input.get_axis("Left", "Right")
	
	if not is_on_floor():
		velocity += Vector2.DOWN * GRAV_ACC * delta
	if direction:
		velocity.x = direction * SPEED
		arm_impulse_response(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func arm_impulse_response(instantaneous_acceleration: Vector2) -> void:
	var arm: Array[RigidBody2D] = [$Arm/Elbow, $Arm/Wrist]
	var impulse: Vector2;
	
	for body in arm:
		impulse = body.mass * instantaneous_acceleration * 0.2
		body.apply_impulse(impulse)
