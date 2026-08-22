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

enum PlayerState {
	IDLE,
	CHARGING,
	ATTACKING,
	PARRYING,
	MOVING,
	CLIMBING,
	DYING
}

var state: PlayerState = PlayerState.IDLE

signal got_parried(attacker)

var _is_animation_flipped: bool = false # if false player is looking right

func _physics_process(delta: float) -> void:
	var defending: bool = Input.is_action_just_pressed("Defend") # parry
	var charging: bool = Input.is_action_just_pressed("Attack") # charge
	var releasing: bool = Input.is_action_just_released("Attack") # whack
	
	if defending or charging or releasing :
		print("defending: "+str(defending)+" charging: "+str(charging)+" releasing: "+str(releasing))

	if charging and not defending and state != PlayerState.CHARGING:
		state = PlayerState.CHARGING
		$AnimatedSprite2D.animation = &"charging"
	elif releasing and state != PlayerState.ATTACKING:
		state = PlayerState.ATTACKING
		$AnimatedSprite2D.animation = &"attack"
	elif defending and state != PlayerState.PARRYING:
		state = PlayerState.PARRYING
		$AnimatedSprite2D.animation = &"parry"

	if state not in [PlayerState.DYING, PlayerState.ATTACKING, PlayerState.PARRYING]:
		if not is_on_floor() && state != PlayerState.CLIMBING:
			velocity += get_gravity() * delta
			
		var direction : float = Input.get_axis("Left", "Right")
		if direction != 0.0:
			if state != PlayerState.MOVING:
				state = PlayerState.MOVING
				$AnimatedSprite2D.animation = &"walk"
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if velocity.x == 0 :
			if state != PlayerState.IDLE:
				state = PlayerState.IDLE
				$AnimatedSprite2D.animation = &"idle"
			
		if Input.is_action_pressed("ClimbUp"):
			if is_climbable():
				state = PlayerState.CLIMBING
				
		if state == PlayerState.CLIMBING:
			climb()
			
		face_mouse_direction()
		
		
		move_and_slide()
		
	if state == PlayerState.CHARGING:
		charge_time = move_toward(charge_time, max_charge_time, delta)
	else : charge_time = 0.0


func face_mouse_direction() -> void:
	var mouse_position: Vector2;

	mouse_position = get_global_mouse_position()
	if (mouse_position.x - global_position.x > 0):
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

#func hit() -> void:
	#var bodies_in_hitbox: Array[Node2D];
#
	#damage_multiplier = (charge_time / max_charge_time)
	#bodies_in_hitbox = $Weapon.get_overlapping_bodies()
	#print(bodies_in_hitbox)
	#for body in bodies_in_hitbox:
		#if body.is_in_group(&"enemy"):
			#body.hurt(damage_multiplier)
	#$AnimatedSprite2D.animation = &"idle"
	#state = PlayerState.IDLE
	#print(33)

func hurt(entity_hurting: Node2D, damage_dealt: float) -> void:
	if state == PlayerState.PARRYING:
		parry(entity_hurting)

	else:
		health -= damage_dealt
		if health <= 0:
			state = PlayerState.DYING
			$AnimatedSprite2D.animation = &"die"

func parry(attacker: Node2D) -> void:
	got_parried.emit(attacker)

func is_climbable() -> bool:
	for area in $InteractionArea.get_overlapping_areas():
		if area.is_in_group("ladder"):
			return true

	return false

func climb() -> void:
	if not is_climbable():
		state = PlayerState.IDLE
		velocity.y = 0
		return

	if Input.is_action_pressed("ClimbUp"):
		velocity.y = climb_velocity
	elif Input.is_action_pressed("ClimbDown"):
		velocity.y = -climb_velocity
	else:
		velocity.y = 0
		
func _on_animated_sprite_2d_animation_finished() :
	if state == PlayerState.DYING :
		var menu = load("res://scenes/menus/main_manu.tscn")
		get_tree().change_scene_to_packed(menu)
		self.queue_free()
		
func get_cam() -> Camera2D : 
	return $Camera2D
