extends Weapon

const MAX_bounces = 8

func fire():
	var bounces = 0
	var targetpos = global_position
	var targetdir = get_local_mouse_position().normalized()
	while true:
		var query = PhysicsRayQueryParameters2D.create(targetpos, targetpos + targetdir * 1600, 1 << 0 | 1 << 2)
		var result = get_viewport().world_2d.direct_space_state.intersect_ray(query)
		if !result.is_empty() and !(bounces >= MAX_bounces):
			#if collider is enemy TODO
			#elif collider is Reverber Projectile TODO
			#else
			targetpos = result.get("position") + result.get("normal")
			targetdir = targetdir.bounce(result.get("normal").normalized())
			get_child(bounces).global_position = targetpos
			bounces += 1
		else:
			break
	print(bounces)
