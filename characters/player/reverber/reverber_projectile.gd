extends Projectile
class_name ReverberWave

func _process(delta: float) -> void:
	scale += Vector2.ONE * delta
	scale = scale.minf(3.0)

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(7.0, Vector2.from_angle(rotation)*1.5)
	else:
		queue_free()
