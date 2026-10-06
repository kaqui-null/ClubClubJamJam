extends Node2D

@export var Kc: float = 10
@export var Kp: float = 10
@export var Ki: float = 20
@export var Kd: float = 2
@export var Kdamp: float = -1

@onready var Wrist: RigidBody2D = $Wrist
@onready var Elbow: RigidBody2D = $Elbow
@onready var PassiveAttractor: Node2D = $PassiveAttractor
@onready var arm_length: float = Wrist.position.length()

var integral: Vector2;
var previous_error: Vector2;

func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position().limit_length(arm_length)

	if Input.is_action_pressed("Attack"):
		constant_force($Wrist, mouse_pos)
		proportional_force($Wrist, mouse_pos)
		integral = integral_force($Wrist, integral, mouse_pos, delta)
		previous_error = derivative_force($Wrist, previous_error, mouse_pos, delta)
	else:
		integral = Vector2.ZERO
		constant_force($Wrist, PassiveAttractor.position)
		damp_force($Wrist)
		damp_force($Elbow)
		
func derivative_force(body: RigidBody2D, prev_error: Vector2, target: Vector2, delta: float) -> Vector2:
	var error: Vector2 = target - body.position
	
	body.apply_central_force(Kd * (error - prev_error) / delta)
	return error

func integral_force(body: RigidBody2D, integral: Vector2, target: Vector2, delta: float) -> Vector2:
	var error: Vector2 = target - body.position
	
	integral += error * delta
	body.apply_central_force(Ki * integral)
	return integral

func proportional_force(body: RigidBody2D, target: Vector2) -> void:
	body.apply_central_force(Kp * (target - body.position))

func constant_force(body: RigidBody2D, target: Vector2) -> void:
	body.apply_central_force(Kc * (target - body.position))

func damp_force(body: RigidBody2D) -> void:
	body.apply_central_force(body.linear_velocity * Kdamp)
