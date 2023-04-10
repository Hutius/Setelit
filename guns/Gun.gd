extends Sprite

export (float) var fire_rate = 0.2
export (bool) var single_shot = true
export (Array, int) var spread_angles = [-0.1, 0.1]
export (PackedScene) var bullet_scene

export (NodePath) var joystickRightPath
onready var joystickRight : VirtualJoystick = get_node(joystickRightPath)

var can_shoot: = true
var shooting: = false setget set_shooting
onready var timer: = $Timer
onready var spawn_pos: = $Position2D


func _process(_delta):
	if joystickRight and joystickRight.is_pressed():
		rotation = joystickRight.get_output().angle()



	if (rad2deg(rotation) >= 90 or rad2deg(rotation) <= -90):
		#elf.set_flip_h(false)
		self.flip_v = true
	else:
		self.flip_v = false

func _ready():
	var _timer_connect = timer.connect("timeout", self, 'timeout')
	timer.wait_time = fire_rate



func _unhandled_input(_event):
	
	if _event.is_action_pressed('shoot'):
		set_shooting(true)
	if _event.is_action_released('shoot'):
		set_shooting(false)

	

func set_shooting(value:bool)->void:
	if value && can_shoot:
		shooting = true
		can_shoot = false
		shoot()
	elif !value:
		shooting = false


func timeout():
	if shooting:
		if !single_shot:
			shoot()
		else:
			can_shoot = true
			shooting = false
	else:
		can_shoot = true

func shoot()->void:
	timer.start()
	for angle in spread_angles:
		var bullet:Area2D = bullet_scene.instance()
		bullet.rotation = rotation
		bullet.spawner = owner										#Add player as spawner
		bullet.rotation_degrees += angle
		bullet.global_position = $Position2D.global_position
		get_parent().add_child(bullet)

		
# func shoot_spread():
# 	var rots = [-0.1, 0, 0.1]
# 	for i in range(3):
# 		var bullet_instance = bullet.instance()
# 		bullet_instance.global_position = $muzzle.global_position
# 		bullet_instance.rotation = rotation + rots[i]
# 		get_parent().screen_shaker._shake(0.3, 3)
# 		get_parent().add_child(bullet_instance)
# 	can_fire = false
		

# func shoot():
# 	var bullet_instance = bullet.instance()
# 	bullet_instance.rotation = rotation + rand_range(-0.1, 0.1)
# 	bullet_instance.global_position = $muzzle.global_position
# 	get_parent().screen_shaker._shake(0.2, 2)
# 	get_parent().add_child(bullet_instance)
# 	can_fire = false

# func _on_Timer_timeout():
# 	can_fire = true