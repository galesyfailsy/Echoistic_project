extends Area2D

func activate(time: float):
	monitoring = true
	await get_tree().create_timer(time).timeout
	monitoring = false



func _on_body_entered(body: Node2D) -> void:
	if get_tree().get_nodes_in_group("PlayerNode").has(body):
		body.take_damage(global_position.direction_to(body.global_position))
	
