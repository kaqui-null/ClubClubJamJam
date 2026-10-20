@abstract
class_name EnemyAi
extends Node

@export var machine_state_node: StateMachine
@export var hitbox: Area2D
@export var static_sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D
@export var enemy_resource: EnemyResource

func _ready() -> void:
	for child in get_children():
		if child is StateMachine:
			machine_state_node = child
			break
