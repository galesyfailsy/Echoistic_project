extends RigidBody2D

@onready var timer: Timer = $Timer

func _process(_delta: float) -> void:
	if !get_colliding_bodies().is_empty():
		if get_colliding_bodies().has(get_tree().get_first_node_in_group("PlayerNode")):
			_on_timer_timeout()
		elif timer.is_stopped():
			timer.start()

func _on_timer_timeout() -> void:
	$Hitbox.activate(0.1)
	await get_tree().create_timer(0.2).timeout
	queue_free()
