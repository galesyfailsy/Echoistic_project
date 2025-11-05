extends Enemy

const JUMPFORCE = -450.0

var target: Node2D

func behavior():
	if !target:
		target = get_tree().get_first_node_in_group("PlayerNode")
	if !is_on_floor():
		velocity += get_gravity() * get_physics_process_delta_time()
	
	if absf(global_position.x - target.global_position.x) > 48.0:
		velocity.x = lerpf(velocity.x,signf(to_local(target.global_position).x) * Speed * SPEED_CONSTANT, 0.1)
	else:
		velocity.x = lerpf(velocity.x, 0, 0.1)
		attack()
	
	if is_on_floor() and global_position.y - target.global_position.y > 64:
		velocity.y = JUMPFORCE
	
	move_and_slide()
	

func attack(): pass
