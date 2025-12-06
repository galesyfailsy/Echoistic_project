@abstract
extends Node2D
class_name Weapon

@export var PrimaryHitbox: Area2D #If this uses an Area
@export var PrimaryHitRay: RayCast2D #If this uses a raycast
@export var Cooldown: float = 0.0
@abstract func Fire()
func TriggerHit():
	if PrimaryHitbox:
		PrimaryHitbox.call_deferred("set", "monitoring", true)
	elif PrimaryHitRay:
		PrimaryHitRay.enabled = false
func EndHit():
	if PrimaryHitbox:
		PrimaryHitbox.call_deferred("set", "monitoring", false)
	elif PrimaryHitRay:
		PrimaryHitRay.enabled = false
