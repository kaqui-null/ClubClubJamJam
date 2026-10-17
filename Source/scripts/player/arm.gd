extends Node2D

@export var Kc: float = 10
@export var Kp: float = 15
@export var Ki: float = 50
@export var Kd: float = 1.5
@export var Kdamp: float = -1

@onready var Wrist: RigidBody2D = $Wrist
@onready var Elbow: RigidBody2D = $Elbow
@onready var Shoulder: StaticBody2D = $Shoulder
@onready var PassiveAttractor: Node2D = $PassiveAttractor
@onready var ARM_LENGTH: float = Wrist.position.length()

var integral: Vector2;
var previous_error: Vector2;

func _physics_process(delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position().limit_length(ARM_LENGTH)
	
	if Input.is_action_pressed("Attack"):
		constant_force(Wrist, mouse_pos)
		proportional_force(Wrist, mouse_pos)
		integral = integral_force(Wrist, integral, mouse_pos, delta)
		previous_error = derivative_force(Wrist, previous_error, mouse_pos, delta)
	else:
		integral = Vector2.ZERO
		previous_error = Vector2.ZERO
		constant_force(Wrist, PassiveAttractor.position)
		damp_force(Wrist)
		damp_force(Elbow,0.5)

#region Force Types
func derivative_force(body: RigidBody2D, prev_error: Vector2, target: Vector2, delta: float, additional_multiplier: float = 1) -> Vector2:
	var error: Vector2 = target - body.position
	
	body.apply_central_force(Kd * additional_multiplier * (error - prev_error) / delta)
	return error

func integral_force(body: RigidBody2D, integral: Vector2, target: Vector2, delta: float, additional_multiplier: float = 1) -> Vector2:
	var error: Vector2 = target - body.position
	
	integral += error * delta
	body.apply_central_force(Ki * integral)
	return integral

func proportional_force(body: RigidBody2D, target: Vector2, additional_multiplier: float = 1) -> void:
	body.apply_central_force(Kp * additional_multiplier * (target - body.position))

func constant_force(body: RigidBody2D, target: Vector2, additional_multiplier: float = 1) -> void:
	body.apply_central_force(Kc * additional_multiplier * (target - body.position))

func damp_force(body: RigidBody2D, additional_multiplier: float = 1) -> void:
	body.apply_central_force(body.linear_velocity * Kdamp * additional_multiplier)
#endregion

## Normal impulse concepts dont work here and the closest effect to what I want comes from jumbling numbers around randomly xd
func impulse_sync(inst_vel_change: Vector2) -> void:
	Wrist.apply_impulse(inst_vel_change * Wrist.mass, 0.5*(Elbow.position - Wrist.position))
	Elbow.apply_impulse(inst_vel_change * Elbow.mass, Shoulder.position - Elbow.position)
