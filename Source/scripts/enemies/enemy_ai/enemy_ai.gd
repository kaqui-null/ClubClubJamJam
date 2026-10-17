extends Node

@export var machine_state_node: StateMachine

func _ready() -> void:
	for child in get_children():
		if child is StateMachine:
			machine_state_node = child
			break

func _process(delta: float) -> void:
	pass
