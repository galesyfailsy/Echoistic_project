extends Enemy

@onready var sightline: RayCast2D = $sightline
var detonating: bool = false

@onready var hitbox: Area2D = $Hitbox

func behavior():
	sightline.target_position = to_local(target.global_position)
	if !sightline.is_colliding() and !detonating:
		if $Timer.is_stopped(): $Timer.start(2.0)
		if global_position.distance_to(target.global_position) > 80:
			velocity = global_position.direction_to(target.global_position) * SPEED_CONSTANT * Speed
		else:
			velocity = velocity.lerp(Vector2.ZERO, 0.1)
	move_and_slide()

func detonate():
	detonating = true
	await get_tree().create_timer(1.0).timeout
	hitbox.activate(1.0)
	await get_tree().create_timer(1.5).timeout
	queue_free()

func die():
	if !detonating:
		detonate()

func _on_timer_timeout() -> void:
	if !detonating:
		detonate()
