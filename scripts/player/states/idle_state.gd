class_name IdleState
extends State

var direction: float

func enter() -> void:
	#target.change_animation("idle")
	pass

func update(delta: float) -> void:
	# Walk input
	if direction:
		machine.change_state("WalkState")
	
	# Jump input or start falling
	if Input.is_action_just_pressed("Jump") or !target.is_on_floor():
		machine.change_state("JumpState")
	
	# Climb input
	if target.is_climbable():
		machine.change_state("ClimbState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")

func exit() -> void:
	pass
