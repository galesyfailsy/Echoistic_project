@abstract
class_name Weapon extends Node2D

@export var Damage: float = 5.0
@export var ReloadTime: float = 2.0

var reload = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("fire") and reload <= 0:
		reload = ReloadTime
		fire()
	elif reload > 0:
		reload -= delta

@abstract func fire()
