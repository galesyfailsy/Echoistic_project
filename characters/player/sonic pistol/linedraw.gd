extends Sprite2D

func _draw() -> void:
	for l in get_parent().lines.keys():
		draw_polyline(l, Color(0.541, 0.0, 0.0, get_parent().lines.get(l)), 2.0)
