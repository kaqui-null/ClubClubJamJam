extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var hand_pos_old: Vector2 = $MainHand.position
@onready var hand_constraints: Dictionary[StringName, float] = {
	max_distance = $HandReach.shape.radius,
	min_distance = 10,
	blind_angle = deg_to_rad(30)
}

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func update_hand_position(delta: float) -> void:
	# NOTE: local coordinates
	var mouse_pos: Vector2 = $HandReach.get_local_mouse_position()
	
	
	$MainHand.position = mouse_pos 
