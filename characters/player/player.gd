extends CharacterBody2D

#Base speed
const SPEED = 600.0
#Jump force
const JUMPFORCE = -450.0
#Lerp weight for movement, clamped between 0 (Standing still) and 3 (3x base speed)
var move_dir: float = 0.0:
	set(value):
		move_dir = clampf(value, -3.0, 3.0)

#How long it takes to reach the base speed value
const BASE_ACCELERATION_TIME = 1.0
#How long it takes to reach 2x and 3x base speed values. 
const EXTRA_ACCELERATION_TIME = 0.2

func _physics_process(_delta: float) -> void:
	input_buffers()
	move_process()

var jump_buffer: float = 0.0
const MAX_jumpbuffer = 0.1

var coyote_time: float = 0.0
const MAX_coyote_time = 0.1

const MAX_intowallbuffer = 0.05
var into_wall_buffer = 0.0

func input_buffers():
	if jump_buffer > 0.0:
		jump_buffer -= get_physics_process_delta_time()
	if coyote_time > 0:
		coyote_time -= get_physics_process_delta_time()
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = MAX_jumpbuffer
	if is_on_floor():
		coyote_time = MAX_coyote_time
	elif is_on_wall():
		coyote_time = MAX_coyote_time
	

#Movement handling
func move_process():
	if !is_on_floor():
		var grav = get_gravity()
		if is_on_wall(): grav /= 3.0
		velocity += grav * get_physics_process_delta_time()
	
	var input = Input.get_axis("left", "right")
	if input:
		if absf(velocity.x) < SPEED:
			move_dir += input * 0.05
		else:
			move_dir += input * 0.01
	else:
		move_dir = lerpf(move_dir, 0.0, 0.2)
	velocity.x = SPEED * move_dir
	
	if jump_buffer > 0.0 and coyote_time > 0:
		coyote_time = 0.0
		jump_buffer = 0.0
		if is_on_wall():
			velocity.x = get_wall_normal().x * JUMPFORCE
			move_dir = get_wall_normal().x
		velocity.y = JUMPFORCE
		
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2
	#
	#if target_direction == -get_wall_normal().x:
		#into_wall_buffer += get_process_delta_time()
	#else:
		#into_wall_buffer = 0.0
	#
	#if into_wall_buffer > MAX_intowallbuffer:
		#move_dir = 0.0
	
	move_and_slide()

#Combat handling
func combat_process(): pass
