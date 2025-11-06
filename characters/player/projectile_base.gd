@abstract
extends Area2D
class_name Projectile

@export var Speed: float = 1.0

func _physics_process(delta: float) -> void:
	global_position += Vector2.from_angle(rotation) * delta * 600.0 * Speed
