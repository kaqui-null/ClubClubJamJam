extends Control

@onready var packed_main: PackedScene = load("res://scenes/menus/main_manu.tscn")

func exit_button_pressed() -> void:
	get_tree().change_scene_to_packed(packed_main)
