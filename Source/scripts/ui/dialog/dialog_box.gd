extends Control

@export var dialog_resource: DialogResource
@export var opening_time: float = 1.0

@onready var rect_node: ColorRect = $CanvasLayer/ColorRect
@onready var text_node: RichTextLabel = $CanvasLayer/ColorRect/RichTextLabel
@onready var is_open: bool = false

func _ready() -> void:
	rect_node.visible = false
	
	if dialog_resource == null: return
	set_dialog()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Jump") and is_open):
		next_dialog()

func set_dialog() -> void:
	text_node.visible_ratio = 0.0
	text_node.text = dialog_resource.dialog_texts[dialog_resource.current_dialog]

# Tries to go to the next dialog from the resource
func next_dialog() -> void:
	if (dialog_resource == null):
		return
	
	if (not has_next_dialog()):
		close_dialog()
	
	var tween := create_tween()
	
	text_node.clear()
	pass_text()
	
	tween.tween_property(text_node, "visible_ratio", 1.0, opening_time)

# Pass the string from the array
func pass_text() -> void:
	text_node.visible_ratio = 0.0
	dialog_resource.current_dialog += 1
	text_node.add_text(dialog_resource.dialog_texts[dialog_resource.current_dialog])

func open_dialog() -> void:
	rect_node.visible = true
	is_open = true
	
	set_dialog()
	var tween := create_tween()
	
	tween.tween_property(text_node, "visible_ratio", 1.0, opening_time)

func close_dialog() -> void:
	rect_node.visible = false
	is_open = false
	
	dialog_resource.current_dialog = 0
	text_node.visible_ratio = 0.0
	text_node.text = dialog_resource.dialog_texts[dialog_resource.current_dialog]

# Checks if the are more dialogs left
func has_next_dialog() -> bool:
	var current_length := dialog_resource.current_dialog
	var max_length := dialog_resource.dialog_texts.size()
	
	return current_length + 1 < max_length
