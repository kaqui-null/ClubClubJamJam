extends CharacterBody2D

var health: float = 100

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var climb_velocity: float = -100.0

var movement_direction: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.RIGHT

var damage_multiplier: float = 0.0
var charge_time: float = 0.0
@export var max_charge_time: float;

enum State {
	IDLE,
	CHARGING,
	ATTACKING,
	PARRYING,
	MOVING,
	CLIMBING
}

var state: State = State.IDLE

signal got_parried(attacker)

var _is_animation_flipped: bool = false # if false player is looking right

func _physics_process(delta: float) -> void:
	movement(delta)
	print(state)

	if state == State.CHARGING:
		charge_time = move_toward(charge_time, max_charge_time, delta)

#------------------------------------------------

func _unhandled_input(event):
	var defending: bool = event.is_action_pressed("Defend")
	var readying: bool = event.is_action_pressed("Attack")
	var releasing: bool = event.is_action_released("Attack")

	if readying and not defending:
		state = State.CHARGING
		charge_time = 0.0
		print("Is charging..")
	elif releasing:
		hit()
		print(charge_time)
	elif defending:
		state = State.PARRYING

func movement(delta: float) -> void:
	var direction: float;

	if not is_on_floor() && state != State.CLIMBING:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	direction = Input.get_axis("Left", "Right")
	if direction:
		state = State.MOVING
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_pressed("ClimbUp"):
		if is_climbable():
			state = State.CLIMBING

	if state == State.CLIMBING:
		climb()

	face_mouse_direction()
	move_and_slide()

func face_mouse_direction() -> void:
	var mouse_position: Vector2;

	mouse_position = get_viewport().get_mouse_position()
	if (mouse_position.x - position.x > 0):
		facing_direction = Vector2.RIGHT
		if _is_animation_flipped:
			$AnimatedSprite2D.flip_h = false
			_is_animation_flipped = false
			$Weapon/Hitbox.position *= -1
	else:
		facing_direction = Vector2.LEFT
		if not _is_animation_flipped:
			$AnimatedSprite2D.flip_h = true
			_is_animation_flipped = true
			$Weapon/Hitbox.position *= -1

func hit() -> void:
	var bodies_in_hitbox: Array[Node2D];

	state = State.ATTACKING
	damage_multiplier = (charge_time / max_charge_time)
	bodies_in_hitbox = $Weapon.get_overlapping_bodies()
	print(bodies_in_hitbox)
	for body in bodies_in_hitbox:
		if body.is_in_group(&"enemy"):
			body.hurt(damage_multiplier)
	state = State.IDLE

func hurt(entity_hurting: Node2D, damage_dealt: float) -> void:
	if state == State.PARRYING:
		print("parrying")
		parry(entity_hurting)
	else:
		health -= damage_dealt
		if health <= 0:
			queue_free()

func parry(attacker: Node2D) -> void:
	got_parried.emit(attacker)

func is_climbable() -> bool:
	for area in $InteractionArea.get_overlapping_areas():
		if area.is_in_group("ladder"):
			return true
	
	return false

func climb() -> void:
	if not is_climbable():
		state = State.IDLE
		velocity.y = 0
		return
	
	if Input.is_action_pressed("ClimbUp"):
		velocity.y = climb_velocity
	elif Input.is_action_pressed("ClimbDown"):
		velocity.y = -climb_velocity
	else:
		velocity.y = 0
