class_name DeathState
extends State

var animation_sprite: AnimatedSprite2D

func enter() -> void:
	# TODO: declare animation_sprite as the player's AnimatedSprite2D when ready
	
	await animation_sprite.animation_finished
	
	# Intial screen restart, may change later
	get_tree().reload_current_scene()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Gravity
	if not target.is_on_floor():
		target.velocity.y += target.GRAV_ACC * delta
	
	target.move_and_slide()

func exit() -> void:
	pass
