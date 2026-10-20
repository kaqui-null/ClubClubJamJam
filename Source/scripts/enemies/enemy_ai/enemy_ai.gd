class_name EnemyAi
extends Node

# Node variables
@export_category("Enemy Nodes")
@export var machine_state_node: StateMachine
@export var hitbox: Area2D
@export var static_sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D

# Resource variables
@export_category("Variable Resources")
@export var enemy_values: EnemyValues
@export var enemy_actions: EnemyActions

func _ready() -> void:
	for child in get_children():
		if child is StateMachine:
			machine_state_node = child
			break
