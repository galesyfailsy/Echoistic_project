extends Projectile
class_name BoomboxBomb

@onready var timer: Timer = $Timer
@onready var collider: CollisionShape2D = $boom/CollisionShape2D

var damage = 10.0

func _process(delta: float) -> void:
	Speed = maxf(Speed - delta, 0.0)
	if collision and collision.get_normal():
		velocity = velocity.bounce(collision.get_normal())
	
	if Speed == 0.0 and timer.is_stopped():
		timer.start()

func _on_timer_timeout() -> void:
	collider.disabled = false
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_boom_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage, global_position.direction_to(body.global_position) * 4)

func _on_autodet_timer_timeout() -> void:
	Speed = 0.0

func quickdetonate() :
	collider.scale /= 2
	damage *= 2
