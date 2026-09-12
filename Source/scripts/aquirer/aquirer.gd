extends Area2D

func _physics_process(delta: float) -> void: 
	for body in get_overlapping_bodies() :
		if (body.is_in_group("aqo") &&
		   body.has_method("aquire_condition") &&
		   body.has_method("aquire")):
			if body.aquire_condition() :
				body.aquire()
	
	var ms : Vector2 = get_global_mouse_position()
	global_position = ms
