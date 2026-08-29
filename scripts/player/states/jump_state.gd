class_name JumpState
extends State

var direction: int
var velocity: Vector2

func enter() -> void:
	#target.change_animation("jump")
	
	velocity = target.velocity
	if Input.is_action_pressed("Jump"):
		velocity.y = target.jump_velocity

func update(delta: float) -> void:
	# Touched ground
	if target.is_on_floor():
		machine.change_state("IdleState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")
	
	# Gravity
	if not target.is_on_floor():
		velocity += target.get_gravity() * delta
	
	# Moving on air
	if direction:
		velocity.x = direction * target.speed
	
	target.move_and_slide()

func exit() -> void:
	pass
