extends CharacterBody2D

@export var SPEED: float = 100.0
@export var GRAV_ACC: float = (35 / 1.8) * 9.81

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float) -> void:
	var direction: float = Input.get_axis("Left", "Right")
	
	if not is_on_floor():
		velocity += Vector2.DOWN * GRAV_ACC * delta
	if direction:
		velocity.x = direction * SPEED
		$Arm/Elbow.apply_impulse(Vector2.RIGHT * direction * SPEED * $Arm/Elbow.mass * 0.2)
		$Arm/Wrist.apply_impulse(Vector2.RIGHT * direction * SPEED * $Arm/Wrist.mass * 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
