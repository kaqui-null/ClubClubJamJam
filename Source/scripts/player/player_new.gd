extends CharacterBody2D

signal got_parried(attacker)

@export var SPEED: float = 100.0
@export var JUMP_SPEED: float = -400.0
@export var GRAV_ACC: float = (35 / 1.8) * 9.81 ## Normalized with player height in pixels to imitate real world g.

var health: float = 100

@onready var machine_state_node: StateMachine = get_node("StateMachine")
@onready var interaction_area: Area2D = get_node("InteractionArea")

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float) -> void:
	var old_velocity: Vector2 = velocity
	var direction: float = Input.get_axis("Left", "Right")
	
	if not is_on_floor():
		velocity += Vector2.DOWN * GRAV_ACC * delta
	if direction:
		velocity.x = direction * SPEED
		arm_impulse_response(velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func get_current_state() -> String:
	machine_state_node = get_node("StateMachine")
	return machine_state_node.current_state.name

## Make arm independent of the inputted [code]instantaneous_acceleration[/code]. [br][br]
## This is to attempt to make the arm not react too much to player's movement 
## by applying an impulse that creates a similar change in velocity.
func arm_impulse_response(instantaneous_acceleration: Vector2) -> void:
	var arm: Array[RigidBody2D] = [$Arm/Elbow, $Arm/Wrist]
	var impulse: Vector2;
	
	for body in arm:
		impulse = body.mass * instantaneous_acceleration * 0.2
		body.apply_impulse(impulse)

func is_climbable() -> bool:
	for area: Area2D in interaction_area.get_overlapping_areas():
		if area.is_in_group("ladder"):
			return true
	
	return false

# TODO: Create a Parry function, preferably on ParryState
func hurt(entity_hurting: Node2D, damage_dealt: float) -> void:
	if get_current_state() == "ParryState":
		#parry(entity_hurting)
		pass

	else:
		health -= damage_dealt
		if health <= 0:
			machine_state_node.change_state("DieState")
			#$AnimatedSprite2D.animation = &"die"
