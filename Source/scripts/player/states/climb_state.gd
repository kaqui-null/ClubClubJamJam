class_name ClimbState
extends State

var direction: float
var velocity: Vector2

func enter() -> void:
	velocity = Vector2.ZERO

func update(delta: float) -> void:
	# Reached floor
	if target.is_on_floor():
		machine.change_state("IdleState")
	
	# Try to jump
	if Input.is_action_just_pressed("Jump"):
		machine.change_state("JumpState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("ClimbUp", "ClimbDown")
	
	velocity.y = direction * target.climb_velocity
	
	target.move_and_slide()

func exit() -> void:
	pass
