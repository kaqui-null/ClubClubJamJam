@abstract class_name State
extends Node

var machine: StateMachine

func _ready() -> void:
	machine = get_parent()

@abstract func enter() -> void
@abstract func update(delta: float) -> void
@abstract func physics_update(delta: float) -> void
@abstract func exit() -> void
