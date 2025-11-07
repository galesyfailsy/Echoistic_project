extends Projectile
class_name ReverberWave

@onready var collisionshape: CollisionShape2D = $CollisionShape2D

func _process(delta: float) -> void:
	collisionshape.scale = (collisionshape.scale + (Vector2.ONE * delta)).minf(3.0)
	if collision:
		if collision.get_collider() is Enemy:
			collision.get_collider().take_damage(7.0, global_position.direction_to(collision.get_collider().global_position))
		elif collision.get_collider() is BoomboxBomb:
			collision.get_collider().Speed += 0.2
		else:
			queue_free()
