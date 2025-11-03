extends CharacterBody2D

const SPEED = 600.0
var moveweight: float = 0.0:
	set(value):
		moveweight = clampf(value, -1.0, 1.0)

const JUMPFORCE = -450.0
const MAX_jumpbuffer = 0.1
var jumpbuffer: float = 0.0

const DASHSPEED = SPEED * 2
const MAX_dashbuffer = 0.1
const DASH_DURATION = 0.25
var dashbuffer: float = 0.0
var dashtime: float = 0.0
var can_dash: bool = true

const MAX_coyotetime = 0.1
var coyotetime: float = 0.0

func _physics_process(_delta: float) -> void:
	time_buffers_process()
	moveprocess()

func time_buffers_process():
	if jumpbuffer > 0: jumpbuffer -= get_physics_process_delta_time()
	if dashbuffer > 0: dashbuffer -= get_physics_process_delta_time()
	if coyotetime > 0: coyotetime -= get_physics_process_delta_time()
	
	if Input.is_action_just_pressed("jump"):
		jumpbuffer = MAX_jumpbuffer
	if Input.is_action_just_pressed("dash"):
		dashbuffer = MAX_dashbuffer
	if is_on_floor():
		coyotetime = MAX_coyotetime

func moveprocess(): 
	if dashtime <= 0.0:
		if !is_on_floor():
			velocity += get_gravity() * get_physics_process_delta_time()
		else:
			can_dash = true
		
		var input = Input.get_axis("left","right")
		if input:
			moveweight += input * get_physics_process_delta_time()
			if signf(input) != signf(moveweight) and absf(moveweight) > 0.25 and is_on_wall():
				moveweight = get_wall_normal().x
		else:
			moveweight -= signf(moveweight) * get_physics_process_delta_time()
			if absf(moveweight) < 0.01: moveweight = 0.0
		
		velocity.x = moveweight * SPEED
		
		if jumpbuffer > 0 and coyotetime > 0:
			velocity.y = JUMPFORCE
		
		if can_dash and dashbuffer > 0:
			can_dash = false
			dashtime = DASH_DURATION
			velocity = get_local_mouse_position().normalized() * DASHSPEED
			moveweight = 0.0
		
		move_and_slide()

	else:
		dashtime -= get_physics_process_delta_time()
		if dashtime <= 0:
			velocity /= 2.0
		else:
			var collision = move_and_collide(velocity * get_physics_process_delta_time())
			if collision:
				velocity = velocity.bounce(collision.get_normal()) * 1.1
				moveweight = collision.get_normal().x
			
	
	
