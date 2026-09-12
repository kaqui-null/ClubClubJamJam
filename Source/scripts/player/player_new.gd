extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_SPEED: float = -400.0
@export var GRAV_ACC: float = (35 / 1.8) * 9.81 ## Normalized with player height in pixels to imitate real world g.

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

## Make arm independent of the inputted [code]instantaneous_acceleration[/code]. [br][br]
## This is to attempt to make the arm not react too much to player's movement 
## by applying an impulse that creates a similar change in velocity.
func arm_impulse_response(instantaneous_acceleration: Vector2) -> void:
	var arm: Array[RigidBody2D] = [$Arm/Elbow, $Arm/Wrist]
	var impulse: Vector2;
	
	for body in arm:
		impulse = body.mass * instantaneous_acceleration * 0.2
		body.apply_impulse(impulse)

# TODO: Create function to check if player can climb
#func is_climbable() -> bool:
	#for area: Area2D in $CollisionShape2D.get_overlapping_areas():
		#if area.is_in_group("ladder"):
			#return true
	#
	#return false
