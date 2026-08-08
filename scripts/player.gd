extends CharacterBody2D

var health: float = 100

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var movement_direction: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.RIGHT

var damage_multiplier: float = 0.0
var charge_time: float = 0.0
@export var max_charge_time: float
@export var max_parry_time: float

var living: bool = true
enum State {
	IDLE,
	CHARGING,
	ATTACKING,
	MOVING
	}
var state = State.IDLE

signal got_parried(attacker)

var _is_animation_flipped: bool = false # if false player is looking right

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("Left", "Right")
	if direction:
		state = State.MOVING
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if state == State.CHARGING:
		charge_time += delta

	face_mouse_direction()
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("Attack"):
		state = State.CHARGING
		charge_time = 0.0
	elif event.is_action_released("Attack"):
		hit(charge_time)

func face_mouse_direction():
	var mouse_position = get_viewport().get_mouse_position()

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

func hit(time_charging: float):
	var bodies_in_hitbox: Array[Node2D];

	state = State.ATTACKING
	damage_multiplier = (time_charging / max_charge_time)
	bodies_in_hitbox = $Weapon.get_overlapping_bodies()
	for body in bodies_in_hitbox:
		if body.is_in_group(&"enemy"):
			body.get_script().hurt(damage_multiplier)
	state = State.IDLE


func hurt(entity_hurting: Node2D, damage_dealt: float):
	if charge_time <= max_parry_time:
		parry(entity_hurting)
	else:
		health -= damage_dealt
	print(health)

func parry(attacker: Node2D):
	got_parried.emit(attacker)

func die():
	if not living:
		queue_free()
