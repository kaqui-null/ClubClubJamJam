class_name EnemySpawner
extends Node2D

@export_group("Spawner Setup")
## If false, Spawner must be triggered manually
@export var spawn_on_start: bool = true

## Spawner disappears after spawn all enemies
@export var disappears_on_spawns: bool = true

## If true, reduces number of enemies
@export var reduce_waves_count: bool = true

## Spawner instantiation Cooldown
@export var spawn_timer_offset: float = 10.0

@export_group("Enemies Setup")
## Packed Scene of the instantiated Enemy
@export var enemy: PackedScene = null

## Quantity of Enemy waves
@export var number_of_enemies: int = 1

@onready var marker: Marker2D = $SpawnMarker
@onready var timer: Timer = $SpawnTimer

func _ready() -> void:
	timer.wait_time = spawn_timer_offset

	if spawn_on_start:
		_spawn_enemy()
		timer.start()

## Spawns single enemy, without counting down or deleting the spawner
func _spawn_single_enemy() -> void:
	var enemy_node: Node2D = enemy.instantiate()
	enemy_node.global_position = self.global_position
	get_tree().root.add_child.call_deferred(enemy_node)

## Instantiate enemy based on Enemy variable, add to Root tree and starts timer
func _spawn_enemy() -> void:
	if number_of_enemies > 0:
		number_of_enemies -= 1
		
		_spawn_single_enemy()

	elif disappears_on_spawns:
		_disappear()

## Destroys Spawner
func _disappear() -> void:
	queue_free()
