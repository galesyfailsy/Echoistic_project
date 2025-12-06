extends CharacterBody2D

@onready var grapple_ray: RayCast2D = $grapple_ray

const SPEED = 500.0
var moveweight = 0.0:
	set(value):
		moveweight = clampf(value, 0.0, 1.0)
var last_input = 1.0

const JUMPFORCE = -500.0
var jumpbuffer = 0.0
const MAX_jumpbuffer = 0.1
var coyotetime = 0.0
const MAX_coyotetime = 0.1
var was_on_wall = false

var string = 6
const MAX_string = 6
var string_recharge = 0.0
const GRAPPLE_PULLSPEED = SPEED * 2.0
var grappling = false
var grappletarget = Vector2.ZERO
var grapple_collider: PhysicsBody2D

func _physics_process(delta: float) -> void:
	
	if string_recharge > 1.0 and string < MAX_string:
		string_recharge = 0.0
		string += 1
	else:
		string_recharge += delta
	
	if Input.is_action_just_pressed("jump"): jumpbuffer = MAX_jumpbuffer
	else: jumpbuffer -= delta
	if is_on_floor() or is_on_wall_only(): 
		coyotetime = MAX_coyotetime
		if is_on_wall_only():
			was_on_wall = true
		elif is_on_floor():
			was_on_wall = false
	else: coyotetime -= delta
	
	var input = Input.get_axis("left","right")
	var airfactor = 1.0 if is_on_floor() else 0.1
	
	grapple_ray.target_position = get_local_mouse_position().normalized() * 320
	
	if !grappling:
		if !is_on_floor(): 
			if is_on_wall_only() and velocity.y > 0.0:
				velocity += get_gravity() * delta / 10
			else:
				velocity += get_gravity() * delta
			coyotetime -= delta
		else: 
			coyotetime = MAX_coyotetime
		
		if input:
			moveweight += delta * airfactor
			last_input = lerpf(last_input, input, 0.1)
		else:
			moveweight -= delta * airfactor
		
		if Input.is_action_just_pressed("grapple") and string > 0:
			string -= 1
			if grapple_ray.is_colliding():
				grappletarget = grapple_ray.get_collision_point()
			last_input = signf(get_local_mouse_position().x)
			if last_input == 0.0: last_input = 1.0
			grappling = true
		
		velocity.x = lerpf(0.0, SPEED * last_input, moveweight)
	else:
		if global_position.distance_squared_to(grappletarget) < 16**2 or global_position.distance_squared_to(grappletarget) > 400**2:
			grappling = false
		else:
			if velocity.dot(global_position.direction_to(grappletarget)) < 0 and velocity.length() > SPEED / 2:
				velocity = velocity.slerp(global_position.direction_to(grappletarget) * GRAPPLE_PULLSPEED, delta)
			else:
				velocity = global_position.direction_to(grappletarget) * GRAPPLE_PULLSPEED
	if jumpbuffer > 0 and (coyotetime > 0 or grappling):
		jumpbuffer = 0.0
		coyotetime = 0.0
		velocity.y = JUMPFORCE
		if was_on_wall:
			velocity.x = get_wall_normal().x * SPEED
			last_input = signf(get_wall_normal().x) 
		if grappling:
			grappling = false
	
	move_and_slide()
