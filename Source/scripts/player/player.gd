extends CharacterBody2D

signal got_parried(attacker)

@export var SPEED: float = 20.0
@export var JUMP_SPEED: float = -35.0
@export var GRAV_ACC: float = (35 / 1.8) * 9.81 ## Normalized with player height in pixels to imitate real world g.

var health: float = 100

@onready var machine_state_node: StateMachine = get_node("StateMachine")

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float) -> void:
	var old_velocity: Vector2 = velocity
	var direction: float = Input.get_axis("Left", "Right")
	
	if not is_on_floor():
		velocity += Vector2.DOWN * GRAV_ACC * delta
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	$Arm.impulse_sync(velocity)
	move_and_slide()

func get_current_state() -> String:
	machine_state_node = get_node("StateMachine")
	return machine_state_node.current_state.name

# TODO: Create function to check if player can climb
#func is_climbable() -> bool:
	#for area: Area2D in $CollisionShape2D.get_overlapping_areas():
		#if area.is_in_group("ladder"):
			#return true
	#
	#return false

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
