class_name DialogTrigger
extends Area2D

@export var dialog_resource: DialogResource

@onready var dialog_box := get_tree().root.get_node("/root/Dialog")

func _ready() -> void:
	connect("body_entered", on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is Player:
		dialog_box.dialog_resource = dialog_resource
		dialog_box.open_dialog()
