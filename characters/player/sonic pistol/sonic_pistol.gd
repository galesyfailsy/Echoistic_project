extends Weapon

const MAX_bounces = 8
var dampening = 0.0

var lines: Dictionary[PackedVector2Array, float] = {}

func fire():
	var bounces = 0
	var targetpos = global_position
	var targetdir = get_local_mouse_position().normalized()
	var exceptions = []
	var collisionpoints: PackedVector2Array = [
		global_position
	]
	while true:
		var query = PhysicsRayQueryParameters2D.create(targetpos, targetpos + targetdir * 1600, 1 << 0 | 1 << 2)
		query.collide_with_areas = true
		var result = get_viewport().world_2d.direct_space_state.intersect_ray(query)
		if !result.is_empty() and !(bounces >= MAX_bounces):
			dampening += targetpos.distance_to(result.get("position")) / 50.0
			collisionpoints.append(result.get("position"))
			if result.get("collider") is Enemy:
				var target: Enemy = result.get("collider")
				target.take_damage(maxf(1.0, Damage - dampening), targetdir)
				break
			elif result.get("collider") is ReverberWave:
				dampening = -1.0
				exceptions.append(result.get("rid"))
				targetpos = result.get("collider").position
				targetdir = Vector2.from_angle(result.get("collider").rotation)
			else:
				targetpos = result.get("position") + result.get("normal")
				targetdir = targetdir.bounce(result.get("normal").normalized())
				bounces += 1
		else:
			collisionpoints.append(targetdir * 1000.0)
			break
	dampening = 0.0
	lines[collisionpoints] = 1.0

func _process(delta: float) -> void:
	for l in lines.keys():
		if lines.get(l) > 0:
			lines.set(l, lines.get(l) - delta)
			if lines.get(l) <= 0.0:
				lines.erase(l)
	$linedraw.queue_redraw()
