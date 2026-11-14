class_name WaveBossAi
extends Node

@onready var center_spawner: EnemySpawner = $CenterEnemySpawner
@onready var right_spawner: EnemySpawner = $RightEnemySpawner
@onready var left_spawner: EnemySpawner = $LeftEnemySpawner

func spawn_enemies() -> void:
	center_spawner._spawn_single_enemy()
	right_spawner._spawn_single_enemy()
	left_spawner._spawn_single_enemy()

func defeat() -> void:
	queue_free()
