extends CharacterBody2D

#Base speed
const SPEED = 600.0
#Jump force
const JUMPFORCE = -450.0
#Lerp weight for movement, clamped between 0 (Standing still) and 3 (3x base speed)
var moveweight: float = 0.0:
	set(value):
		moveweight = clampf(value, 0.0, 3.0)

#How long it takes to reach the base speed value
const BASE_ACCELERATION_TIME = 1.0
#How long it takes to reach 2x and 3x base speed values. 
const EXTRA_ACCELERATION_TIME = 5.0
#How much dashing increases the moveweight by
const DASH_SPEED = 2400.0
const DASH_BOOST = 0.5

var dash_used: bool = false

var target_direction: float = 0.0

func _physics_process(_delta: float) -> void:
	input_buffers()
	move_process()

var jump_buffer = 0.0
const MAX_jumpbuffer = 0.25
var dash_buffer = 0.0
const MAX_dashbuffer = 0.1
var coyote_time = 0.0
const MAX_coyote_time = 0.1

func input_buffers():
	if jump_buffer > 0.0:
		jump_buffer -= get_physics_process_delta_time()
	if dash_buffer > 0.0:
		dash_buffer -= get_physics_process_delta_time()
	if coyote_time > 0:
		coyote_time -= get_physics_process_delta_time()
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = MAX_jumpbuffer
	if Input.is_action_just_pressed("dash"):
		dash_buffer = MAX_dashbuffer
	if is_on_floor() or is_on_wall_only():
		coyote_time = MAX_coyote_time
	
#Movement handling
func move_process():
	if !is_on_floor():
		velocity += get_gravity() * get_physics_process_delta_time()
	
	if jump_buffer > 0.0 and coyote_time > 0:
		coyote_time = 0.0
		jump_buffer = 0.0
		velocity.y = JUMPFORCE
		if is_on_wall_only():
			velocity.x = get_wall_normal().x * SPEED
			target_direction = get_wall_normal().x
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2
	
	var input = Input.get_axis("left", "right")
	var was_still = is_equal_approx(velocity.x, 0.0)
	if input:
		if was_still:
			target_direction = input
		else:
			target_direction = lerpf(target_direction, input, 0.05)
		if signf(target_direction) == signf(input):
			if velocity.x < SPEED and velocity.x > -SPEED:
				moveweight += get_physics_process_delta_time() / BASE_ACCELERATION_TIME
			else:
				moveweight += get_physics_process_delta_time() / EXTRA_ACCELERATION_TIME
		else:
			moveweight -= get_physics_process_delta_time()
	else:
		moveweight -= get_physics_process_delta_time()
	if velocity.x > SPEED * 3.0:
		velocity.x -= SPEED*get_physics_process_delta_time()*10
	else:
		velocity.x = lerpf(0.0, SPEED * target_direction, moveweight)
	
	
	if dash_buffer > 0 and !dash_used:
		dash_buffer = 0.0
		dash_used = true
		velocity = get_local_mouse_position().normalized() * DASH_SPEED
		moveweight += DASH_BOOST
	
	move_and_slide()
	
	if is_on_wall():
		moveweight = 0.0
		


#Combat handling
func combat_process(): pass
