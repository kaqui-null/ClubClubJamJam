class_name IdleState
extends State

var direction: int

func enter() -> void:
	target.change_animation("idle")

func update(delta: float) -> void:
	# Walk input
	if direction:
		machine.change_state("WalkState")
	
	# Jump input or start falling
	if Input.is_action_just_pressed("Jump") or !target.is_on_floor():
		machine.change_state("JumpState")

func physics_update(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")

func exit() -> void:
	pass
