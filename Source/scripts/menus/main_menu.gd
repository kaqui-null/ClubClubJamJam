extends Control

@export var packed_start: PackedScene
var packed_options: PackedScene = load("res://scenes/menus/options_menu.tscn")

func start_button_pressed() -> void:
	if (not packed_start == null):
		get_tree().change_scene_to_packed(packed_start)
	else:
		printerr('No Start Scene added!')

func options_button_pressed() -> void:
	if (not packed_options == null):
		get_tree().change_scene_to_packed(packed_options)
	else:
		printerr('No Options Scene added!')

func exit_button_pressed() -> void:
	get_tree().quit()
