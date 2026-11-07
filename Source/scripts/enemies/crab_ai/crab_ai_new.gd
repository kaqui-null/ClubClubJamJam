@abstract
class_name CrabAi
extends CharacterBody2D

@export_group("Character Values")
@export var approach_range: float
@export var attack_range: float
@export var flee_range: float
@export var speed: float
@export var damage: float
@export var pipe_damage: float
@export var g_acceleration: float

@export_group("Node Values")
@export var get_player_on_start: bool = false
@export var machine_state_node: StateMachine

var Room: Node
var Player: Node2D

enum {LEFT = -1, RIGHT = 1}
var dir: int

func _ready() -> void:
	# Checks if there's a State Machine Node
	for child in get_children():
		if child is StateMachine:
			machine_state_node = child as StateMachine
	
	if get_player_on_start:
		get_player()

@abstract
func get_player()
