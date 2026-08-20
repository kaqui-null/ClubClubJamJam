
extends Node2D

@onready var old_position: Vector2 = position
@onready var constraints: Dictionary[StringName, float] = {
	max_distance = get_parent().shape.radius,
	min_distance = 10,
	blind_angle = deg_to_rad(30)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	verlet(delta)


func verlet(delta: float) -> void:
	# NOTE positions are local
	var velocity: Vector2 = (position - old_position) / delta
	var grav_acc: float = (35 / 1.8) * 9.81 # scaled per pixel
	print("Velocity before:")
	print(velocity)
	if Input.is_action_pressed("Attack"): # TODO perhaps rename inputs?
		velocity += (get_local_mouse_position() - position).normalized() * grav_acc * delta
	else:
		velocity += Vector2.DOWN * grav_acc * delta
	print("Velocity after:")
	print(velocity)
	print("\n")
	
	if (position + velocity * delta).length() >= constraints["max_distance"]:
		constrain_hand(constraints["max_distance"], velocity, delta)
	elif (position + velocity * delta).length() <= constraints["min_distance"]:
		constrain_hand(constraints["min_distance"], velocity, delta)
	else:
		old_position = position
		position += velocity * delta

func constrain_hand(radius: float, velocity: Vector2, delta: float) -> void:
	var travel_to_rim: 	Vector2 = circle_intercept(radius, position, velocity * delta)
	var boundary: 		Vector2 = position + travel_to_rim
	var circle_tangent: Vector2 = boundary.orthogonal().normalized() 
	var overshoot: 		Vector2 = velocity * delta - travel_to_rim
	var slide_length:	float = overshoot.dot(circle_tangent)
	
	#assert((travel_to_rim).length() < (velocity * delta).length(), \
	#"Displacement needed to hit circle rim is larger than actual displacement.")
	old_position = (boundary - position)*0.999 + position
	position = slide_along_circle(boundary, slide_length * 0.7)

## Returns the resulting position of sliding counter-clockwise along a circle.[br][br]
## Center is assumed to be (0,0) and radius is the initial_pos distance from it.
func slide_along_circle(initial_pos: Vector2, arc_length: float) -> Vector2:
	var angle_change: float = arc_length / initial_pos.length()
	
	return initial_pos.rotated(- angle_change) # accounts for godot doing angles clockwise

## Returns resized input vector from origin that ends at the circle rim. [br][br]
## Input vector cannot be already summed with origin. [br]
## Center is assumed to be (0,0) [br][br]
## Visual showcase: [url] https://www.desmos.com/calculator/boy3ybqtv5
func circle_intercept(radius: float, origin: Vector2, input: Vector2) -> Vector2:
	# using quadratic formula terminology
	var a: float = input.length()**2 
	var b: float = 2 * (input.dot(origin))
	var c: float = origin.length()**2 - radius**2
	var scalar: float;
	
	if origin.length() < radius:
		scalar = quadratic(false, a, b, c)
	elif origin.length() > radius:
		scalar = quadratic(true, a, b, c)
	else:
		scalar = max(quadratic(true, a, b, c), quadratic(false, a, b, c))
	
	return input * scalar

## Checks whether a vector ends at a circle rim. [br] 
## The function assumes that the circle's center is at (0, 0)
func is_on_circle(radius: float, origin: Vector2, input: Vector2) -> bool:
	return is_equal_approx((input + origin).length(), radius)

## Applies the quadratic formula.
func quadratic(minus: bool, a: float, b: float, c: float) -> float:
		if minus:
			return (-b - sqrt(b**2 - 4 * a * c)) / (2 * a)
		else:
			return (-b + sqrt(b**2 - 4 * a * c)) / (2 * a)
