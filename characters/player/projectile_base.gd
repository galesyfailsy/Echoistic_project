@abstract
extends CharacterBody2D
class_name Projectile

@export var Speed: float = 1.0
var collision: KinematicCollision2D

func _physics_process(delta: float) -> void:
	velocity = 600.0 * Speed * Vector2.from_angle(rotation)
	collision = move_and_collide(velocity * delta)
