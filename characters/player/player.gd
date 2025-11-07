extends CharacterBody2D


#region Movement

const SPEED = 600.0
var moveweight: float = 0.0:
	set(value):
		moveweight = clampf(value, -1.0, 1.0)

const JUMPFORCE = -450.0
const MAX_jumpbuffer = 0.1
var jumpbuffer: float = 0.0

const DASHSPEED = SPEED * 2
const MAX_dashbuffer = 0.1
const DASH_DURATION = 0.15
var dashbuffer: float = 0.0
var dashtime: float = 0.0
var can_dash: bool = true

const MAX_coyotetime = 0.1
var coyotetime: float = 0.0

func move_buffers_process():
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
	if knocked_back > 0:
		move_and_slide()
		return
	if dashtime <= 0.0:
		if !is_on_floor():
			velocity += get_gravity() * get_physics_process_delta_time()
		else:
			can_dash = true
		
		var input = Input.get_axis("left","right")
		if input:
			moveweight += input * get_physics_process_delta_time()
			if signf(input) != signf(moveweight) and absf(moveweight) > 0.25 and is_on_wall():
				moveweight = get_wall_normal().x * absf(moveweight)
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
				velocity = velocity.bounce(collision.get_normal())
				var newweight
				if collision.get_normal().x == 0.0:
					newweight = velocity.normalized().x
				else:
					newweight = collision.get_normal().x
				moveweight = newweight
				dashtime = DASH_DURATION
				if collision.get_collider() is Enemy:
					ivtime = MAX_ivtime
					collision.get_collider().take_damage(5.0, -collision.get_normal() * 2.0)
			

#endregion

#region Combat

const MAX_HP = 5
var health: int = 5

var knocked_back: float = 0.0

const MAX_ivtime = 1.0
var ivtime = 0.0

const KB_FORCE = 800.0

func life_buffers_process():
	if knocked_back > 0:
		knocked_back -= get_physics_process_delta_time()
	if ivtime > 0: 
		ivtime -= get_physics_process_delta_time()

func take_damage(dir: Vector2):
	if ivtime > 0: return
	print("hit")
	health -= 1
	if health <= 0:
		return
	knocked_back = 0.2
	ivtime = MAX_ivtime
	velocity = KB_FORCE * dir
#endregion

func _physics_process(_delta: float) -> void:
	life_buffers_process()
	move_buffers_process()
	moveprocess()
