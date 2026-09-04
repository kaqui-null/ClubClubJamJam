class_name JumpState
extends State

var direction: float
var velocity: Vector2

func enter() -> void:
	#target.change_animation("jump")
	
	velocity = target.velocity
	if Input.is_action_pressed("Jump"):
		velocity.y = target.JUMP_SPEED

func update(delta: float) -> void:
	# Touched ground
	if target.is_on_floor():
		machine.change_state("IdleState")
	
	# Climb input
	#if target.is_climbable():
		#machine.change_state("ClimbState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")
	
	# Gravity
	if not target.is_on_floor():
		velocity.y += target.GRAV_ACC * delta
	
	# Moving on air
	if direction:
		velocity.x = direction * target.SPEED
	
	target.move_and_slide()

func exit() -> void:
	pass
