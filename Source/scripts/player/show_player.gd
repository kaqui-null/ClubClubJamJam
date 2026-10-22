class_name PlayerShow
extends Area2D

@export var form: PackedScene

var node: Node2D
var aquired: bool = false

func _ready() -> void:
	add_to_group("aqo")

func aquire() -> void:
	if aquire_condition():
		node = form.instantiate()
		
		if node != null:
			add_child(node)
			aquired = true

func aquire_condition() -> bool:
	# TODO: Implement conditions to aquire, maybe turn it abstract?
	return form != null and not aquired;

func dequire() -> void:
	if node != null:
		node.queue_free()
		node = null
	
	aquired = false
