@abstract
extends CharacterBody2D
class_name Enemy

const SPEED_CONSTANT = 500.0

@export var MaxHealth: float = 15.0
var Health = 1.0
@export var Speed: float = 1.0
@export var KBFactor: float = 1.0

var target: Node2D

func _ready() -> void:
	Health = MaxHealth

func _physics_process(delta: float) -> void:
	if !target:
		target = get_tree().get_first_node_in_group("PlayerNode")
	behavior()

@abstract func behavior()

func take_damage(dmg: float, kb: Vector2):
	Health -= dmg
	if Health <= 0.0:
		print("Down!")
		die()
	velocity = kb * 600.0 * KBFactor
	move_and_slide()

#overwrite to add on-death behavior
func die():
	queue_free()
