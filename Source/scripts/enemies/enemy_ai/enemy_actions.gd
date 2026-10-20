@abstract
class_name EnemyActions
extends Resource

@abstract func IdleAction() -> void
@abstract func AlertAction() -> void

func ReadyingAction(enemy: EnemyAi, time: float) -> void:
	await enemy.create_timer(time).timeout

func HurtState(enemy: EnemyAi, knockback_direction: float) -> void:
	# Enemy knockback
	var velocity: Vector2 = enemy.velocity
	
	velocity.x += enemy.enemy_values.knockback_velocity * knockback_direction
	enemy.velocity = velocity
