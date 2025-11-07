extends Weapon

const BOOMBOX_PROJECTILE = preload("uid://d356ji37gv1ou")

func fire():
	var projectile = BOOMBOX_PROJECTILE.instantiate()
	get_tree().root.add_child(projectile)
	projectile.rotation = get_local_mouse_position().angle()
	projectile.position = global_position
