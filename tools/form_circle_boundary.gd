@tool
extends CollisionPolygon2D

@export var radius: float = 0:
	set(new_radius):
		if new_radius >= 0:
			radius = new_radius
		else:
			radius = 0
		form_circle(radius, amount_of_segments)

@export var amount_of_segments: int = 3:
	set(new_amount):
		if new_amount >= 3:
			amount_of_segments = new_amount
		else:
			amount_of_segments = 3
		form_circle(radius, amount_of_segments)
	

func form_circle(radius: float, segments: int) -> void:
	var angle: float = 0
	var point_array := PackedVector2Array()
	
	while angle < 2 * PI:
		point_array.append(polar_to_cartesian(radius, angle))
		angle += 2 * PI / segments
	polygon = point_array

func polar_to_cartesian(radius: float, angle: float) -> Vector2:
	var out := Vector2()
	
	out.x = radius * cos(angle)
	out.y = radius * sin(angle)
	
	return out
