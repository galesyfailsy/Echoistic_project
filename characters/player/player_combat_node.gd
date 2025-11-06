extends Node2D

var active_weapon: int = 1

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon1"):
		active_weapon = 1
	elif Input.is_action_just_pressed("weapon2") and SaveDataManager.unlocked_reverb:
		active_weapon = 2
	elif Input.is_action_just_pressed("weapon3") and SaveDataManager.unlocked_boombox:
		active_weapon = 3
	
	if Input.is_action_just_pressed("weaponscroll_forward"):
		active_weapon = wrapi(active_weapon+1, 1, 4)
		if !SaveDataManager.unlocked_reverb:
			active_weapon = 1
		elif !SaveDataManager.unlocked_boombox:
			active_weapon = wrapi(active_weapon, 1,3)
		
