@abstract
class_name EnemyAi
extends Node

@export var machine_state_node: StateMachine
@export var hitbox: Area2D
@export var static_sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D

var health = 100.0
var knockback_velocity = 0.0
var weapon_damage: Dictionary = {
	"None": 1.0,
	"Pipe": 1.5,
}

func _ready() -> void:
	for child in get_children():
		if child is StateMachine:
			machine_state_node = child
			break

func _process(delta: float) -> void:
	pass
