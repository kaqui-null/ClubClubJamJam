extends CharacterBody2D

var health: float = 100

enum {IDLE, FOLLOWING, ATTACKING, PARRIED, FLEEING, DEAD}
var state: int;
@export var approach_range: float;
@export var attack_range: float;
@export var flee_range: float;
@export var speed: float;
@export var damage: float;
@export var pipe_damage: float;

var Room: Node;
var Player: Node2D;

enum {LEFT = -1, RIGHT = 1}
var dir: int;

@export var g_acceleration: float;

func _ready() -> void:
	$AttackTimer.wait_time = 9/8 #time for animation to finish
	Room = self.get_parent()
	Timer.new()
	$RayCastR.target_position = Vector2(approach_range, 0)
	$RayCastL.target_position = Vector2(-approach_range, 0)
	change_state(IDLE)
	dir = RIGHT

func _physics_process(delta: float) -> void:
	Player = null
	for raycast: RayCast2D in [$RayCastL, $RayCastR]:
		if raycast.get_collider() and raycast.get_collider().name == &"Player":
			Player = raycast.get_collider();
			if !Player.got_parried.is_connected(parried):
				Player.got_parried.connect(parried)

	match state:
		IDLE:
			idle(delta)
		FOLLOWING:
			following(delta)
		ATTACKING:
			attacking(delta)

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
		ATTACKING:
			$Sprite.animation = &"attacking"
			$AttackTimer.start() #TODO make timer length depend on amount of frames
		FOLLOWING, FLEEING:
			$Sprite.animation = &"moving"
		DEAD:
			$Sprite.animation = &"dying"

			#NOTICE make timer length depend on amount of frames here too
		PARRIED:
			#TODO reverse attack animation and play it or use a non-smear version of attack
			$Sprite.animation = &"stunned"
			$AttackTimer.start()

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
		if absf(Player.global_position.x - self.global_position.x) <= attack_range:
			change_state(ATTACKING)
		else:
			self.velocity.x = dir * speed
	else:
		change_state(IDLE)
	if !is_on_floor():
		self.velocity.y += g_acceleration * delta
	else:
		self.velocity.y = 0

func attacking(delta: float) -> void:
	if Player and absf(Player.global_position.x - self.global_position.x) >= attack_range:
		state = FOLLOWING
	elif !Player:
		state = IDLE

func hurt(multiplier: float):
	health -= pipe_damage * multiplier
	if health <= 0:
		change_state(DEAD)
	print(health)

func hit() -> void:
	Player.hurt(self, damage)

func parried(attacker: Node2D) -> void:
	if attacker.get_instance_id() == self.get_instance_id():
		change_state(PARRIED)

func _on_attack_timer_timeout():
	if state == ATTACKING:
		hit()
		$AttackTimer.start()
	elif state == PARRIED:
		state = ATTACKING

func _on_sprite_animation_finished():
	$Sprite.animation = &"idle"
	if state == PARRIED:
		state = ATTACKING
	elif state == DEAD:
		self.queue_free()
