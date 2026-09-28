@tool
extends EditorScript

enum yo {A, B, C}
# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var sup: yo;
	print(sup)
	pass
