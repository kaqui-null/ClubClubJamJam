class_name StateMachine
extends Node

@export var current_state: State
var states: Dictionary[String, State]

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is State:
			states[child.name] = child
	
	if states.has('IdleState'):
		current_state = states['IdleState']

func _process(delta: float) -> void:
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func change_state(state_name: String) -> void:
	if not states.has(state_name):
		printerr('No {state_name} State found!')
		return
	
	current_state.exit()
	current_state = states[state_name]
	current_state.enter()
