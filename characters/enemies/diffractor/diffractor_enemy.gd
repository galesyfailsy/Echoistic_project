extends Enemy

var tracking: bool = true
@onready var parry_ray: RayCast2D = $ParryRay
@onready var sightray: RayCast2D = $Sightray

const DIFFRACTOR_BOMBS = preload("uid://edpe0yjbj1k")
var time_to_throw: float = 2.0
const MAX_ttot = 2.0


func behavior():
	sightray.target_position = to_local(target.global_position)
	if !is_on_floor(): 
		velocity += get_gravity() * get_physics_process_delta_time()
	if tracking:
		parry_ray.target_position = to_local(target.global_position).normalized() * 500.0
		if absf(global_position.x - target.global_position.x) < 128.0 and !sightray.is_colliding():
			velocity.x = lerpf(velocity.x, signf(global_position.x - target.global_position.x) * SPEED_CONSTANT * Speed, 0.05)
		else:
			velocity.x = lerpf(velocity.x, 0.0, 0.1)
		
		time_to_throw -= get_physics_process_delta_time()
		if time_to_throw <= 0.0:
			time_to_throw = MAX_ttot
			var bomb: RigidBody2D = DIFFRACTOR_BOMBS.instantiate()
			get_tree().root.add_child(bomb)
			bomb.apply_central_impulse(Vector2(
				global_position.distance_to(target.global_position) * signf(target.global_position.x - global_position.x),
				-500.0,
			))
			bomb.global_position = global_position
		
	
	elif parry_ray.enabled:
		if parry_ray.is_colliding():
			parry_ray.get_collider().take_damage(-parry_ray.get_collision_normal())
			parry_ray.enabled = false
	
	move_and_slide()
	

func take_damage(dmg: float, kb: Vector2):
	if target.global_position.distance_to(global_position) < 128.0:
		super.take_damage(dmg, kb)
	elif tracking:
		print("deflected!")
		tracking = false
		await get_tree().create_timer(1.0).timeout
		parry_ray.enabled = true
		await get_tree().create_timer(0.1).timeout
		parry_ray.enabled = false
		tracking = true
