@abstract
extends CharacterBody2D
class_name Enemy

@export var Health: float = 15.0
@export var Speed: float = 1.0
@export var KBFactor: float = 1.0

func _process(_delta: float) -> void:
	behavior()

@abstract func behavior()

func take_damage(dmg: float, kb: Vector2):
	Health -= dmg
	if Health <= 0.0:
		print("Down!")
		die()
	damage_taken()
	velocity = kb * 600.0 * KBFactor
	move_and_slide()

#overwrite to add on-death behavior
func die():
	queue_free()

#overwrite to add on-hit behavior
func damage_taken(): pass
