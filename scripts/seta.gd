extends Sprite2D

var normal_frame = 0
var hit_frame = 1

func press():
	frame = hit_frame

	await get_tree().create_timer(0.1).timeout

	frame = normal_frame
