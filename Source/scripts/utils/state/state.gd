@abstract class_name State
extends Node

var machine: StateMachine
var target: Node2D

func _ready() -> void:
	machine = get_parent()
	
	if get_parent().get_parent():
		target = get_parent().get_parent()

@abstract func enter() -> void
@abstract func update(delta: float) -> void
@abstract func physics_update(delta: float) -> void
@abstract func exit() -> void
