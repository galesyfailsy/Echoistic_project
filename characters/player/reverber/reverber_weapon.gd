extends Weapon

const REVERBER_PROJECTILE = preload("uid://shkr6ad536kb")

func fire():
	var origin = global_position
	var direction = get_local_mouse_position().normalized().angle()
	var projectile = REVERBER_PROJECTILE.instantiate()
	get_tree().root.add_child(projectile)
	projectile.position = origin
	projectile.rotation = direction
