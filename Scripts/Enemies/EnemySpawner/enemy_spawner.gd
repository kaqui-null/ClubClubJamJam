extends Node2D

@export var spawn_on_start: bool = false
@export var enemy: PackedScene

@onready var marker: Marker2D = $SpawnMarker

func _ready() -> void:
	if spawn_on_start:
		_spawn_enemy()

func _process(delta: float) -> void:
	pass

## Instantiate enemy based on Enemy and add to Spawner tree
func _spawn_enemy() -> void:
	var enemy_node = enemy.instantiate()
	add_child(enemy_node)
