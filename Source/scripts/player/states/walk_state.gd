class_name WalkState
extends State

var direction: float
var velocity: Vector2

func enter() -> void:
	velocity = Vector2.ZERO

func update(delta: float) -> void:
	if direction == 0:
		machine.change_state("IdleState")
	
	if Input.is_action_just_pressed("Jump"):
		machine.change_state("JumpState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")
	
	target.velocity.x = direction * target.SPEED
	
	target.move_and_slide()

func exit() -> void:
	pass
