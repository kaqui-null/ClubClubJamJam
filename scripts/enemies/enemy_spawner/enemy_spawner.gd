extends Node2D

## If false, Spawner must be triggered manually
@export var spawn_on_start: bool = true

## Packed Scene of the instantiated Enemy
@export var enemy: PackedScene = null

## Quantity of Enemy waves
@export var number_of_enemies: int = 1

## Spwner instantiation Cooldown
@export var spawn_timer_offset: float = 10.0

@onready var marker: Marker2D = $SpawnMarker
@onready var timer: Timer = $SpawnTimer

func _ready() -> void:
	timer.wait_time = spawn_timer_offset
	
	if spawn_on_start:
		_spawn_enemy()
		timer.start()

## Instantiate enemy based on Enemy variable, add to Root tree and starts timer
func _spawn_enemy() -> void:
	if number_of_enemies > 0:
		number_of_enemies -= 1
	else:
		_disappear()
	
	var enemy_node = enemy.instantiate()
	get_tree().root.add_child.call_deferred(enemy_node)

## Destroys Spawner
func _disappear() -> void:
	queue_free()
