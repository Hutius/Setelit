extends Sprite

var velocity = Vector2()

func _process(_delta):
	var mpos = get_global_mouse_position()
	var ang = (get_global_mouse_position() - self.get_global_position()).angle()

	look_at(mpos)


	if (rad2deg(ang) >= 90 or rad2deg(ang) <= -90):
		#elf.set_flip_h(false)
		self.flip_v = true
	else:
		self.flip_v = false
