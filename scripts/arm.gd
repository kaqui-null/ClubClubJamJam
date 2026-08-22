extends Node2D

@export var DAMP_STRENGTH: float = 5
@export var PASSIVE_FORCE_STRENGTH: float = 200
@export var MOUSE_ATTRACT_STRENGTH: float = 1000

func _physics_process(delta: float) -> void:
	damp($Wrist, $Elbow)
	if Input.is_action_pressed("Attack"):
		var mouse_pos := get_local_mouse_position()
		const_attract(mouse_pos, $Wrist, MOUSE_ATTRACT_STRENGTH)
	else:
		var wrist_rest_pos: Vector2 = $PassiveAttractor.position
		linear_attract(wrist_rest_pos, $Wrist, PASSIVE_FORCE_STRENGTH)

## Directly proportional to distance.
func linear_attract(location: Vector2, body: RigidBody2D, scale: float) -> void:
	var distance_from_target: Vector2 = location - body.position
	
	$Wrist.apply_central_force(distance_from_target * scale)

## Does not scale with distance.
func const_attract(location: Vector2, body: RigidBody2D, scale: float) -> void:
	var distance_from_target: Vector2 = location - body.position
	
	$Wrist.apply_central_force(distance_from_target.normalized() * scale)

## Apply counter-force to movement proportional to velocity for each body in arguments.
func damp(... bodies: Array) -> void:
	for body: RigidBody2D in bodies:
		body.apply_central_force(- body.linear_velocity * DAMP_STRENGTH)
