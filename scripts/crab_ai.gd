extends CharacterBody2D

enum {IDLE, FOLLOWING, ATTACKING, FLEEING, DEAD}
var state: int;
@export var approach_range: float;
@export var attack_range: float;
@export var flee_range: float;
@export var speed: float;
var health: float = 100

var room: Node;
var Player: Node2D = null

enum {LEFT = -1, RIGHT = 1}
var dir: int;

@export var g_acceleration: float;
#var idle_dir_period: float = 5
#var idle_offset: float = 0

func _ready() -> void:
	room = self.get_parent()
	$RayCastR.target_position = Vector2(approach_range,0)
	$RayCastL.target_position = Vector2(-approach_range,0)
	change_state(IDLE)
	dir = RIGHT

func _physics_process(delta: float) -> void:
	Player = null
	for raycast: RayCast2D in [$RayCastL, $RayCastR]:
		if raycast.get_collider() and raycast.get_collider().name == &"Player":
			Player = raycast.get_collider();

	match state:
		IDLE:
			idle(delta)
		FOLLOWING:
			following(delta)
	move_and_slide()
	


func change_state(value: int) -> void:
#NOTICE use ONLY this to change state (animation should change only when state is changed)
	state = value
	animate_from_state(value)

func animate_from_state(_state: int) -> void:
#TODO remove modulate
	match _state:
		IDLE:
			$Sprite.animation = &"idle"
			$Sprite.modulate = Color.GREEN_YELLOW
		ATTACKING:
			$Sprite.animation = &"attacking"
			$Sprite.modulate = Color.CRIMSON
		FOLLOWING, FLEEING:
			$Sprite.animation = &"moving"
			$Sprite.modulate = Color.BLUE
		DEAD:
			$Sprite.animation = &"dying"
			$Sprite.modulate = Color.DIM_GRAY

func idle(delta: float) -> void:
	if Player:
		if absf(Player.global_position.x - self.global_position.x) > attack_range:
			change_state(FOLLOWING)
		else:
			change_state(ATTACKING)
	else:
		self.velocity.x = 0
		if !is_on_floor():
			self.velocity.y += g_acceleration * delta
		else:
			self.velocity.y = 0


func following(delta: float) -> void:
	if Player:
		dir = Player.global_position.x - self.global_position.x
		dir /= absi(dir)
		$Sprite.flip_h = (dir == LEFT)
		self.velocity.x = dir * speed
	else:
		change_state(IDLE)
	if !is_on_floor():
		self.velocity.y += g_acceleration * delta
	else: 
		self.velocity.y = 0

func attacking(delta: float) -> void:
	if Player:
		dir = Player.global_position.x - self.global_position.x
		dir /= absi(dir)
		$Sprite.flip_h = (dir == LEFT)
	
		
		
	pass
