extends Weapon

const MAX_bounces = 8
var dampening = 0.0

func fire():
	var bounces = 0
	var targetpos = global_position
	var targetdir = get_local_mouse_position().normalized()
	while true:
		var query = PhysicsRayQueryParameters2D.create(targetpos, targetpos + targetdir * 1600, 1 << 0 | 1 << 2)
		var result = get_viewport().world_2d.direct_space_state.intersect_ray(query)
		if !result.is_empty() and !(bounces >= MAX_bounces):
			dampening += targetpos.distance_to(result.get("position")) / 50.0
			if result.get("collider") is Enemy:
				var target: Enemy = result.get("collider")
				target.take_damage(maxf(1.0, Damage - dampening), targetdir)
				break
			#elif collider is Reverber Projectile TODO
			else:
				targetpos = result.get("position") + result.get("normal")
				targetdir = targetdir.bounce(result.get("normal").normalized())
				bounces += 1
		else:
			break
	dampening = 0.0
