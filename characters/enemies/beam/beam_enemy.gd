extends Enemy

var target_angle: float = 0.0
var turn_speed = 0.0:
	set(value):
		turn_speed = clampf(value, 0.0, 1.0)
@onready var hitbox: Area2D = $Hitbox

var stopped: bool = false

func behavior():
	if global_position.distance_to(target.global_position) < 430.0:
		target_angle = to_local(target.global_position).angle()
	if hitbox.rotation != target_angle:
		hitbox.rotate(deg_to_rad(0.1) * signf(target_angle -  hitbox.rotation))
	
	if rad_to_deg(absf(hitbox.rotation - target_angle)) < 10 and !stopped:
		hitbox.toggle_activate(true) 
	else:
		hitbox.toggle_activate(false)
	
