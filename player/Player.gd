extends KinematicBody2D


var velocity = Vector2()
var success = false
var FLY = 10
var time = 0
const SPEED = 250
const GRAVITY = 15
const JUMP = 500
const FLOOR = Vector2(0, -1)
const MAX_HP = 100
var health_points = MAX_HP

func _ready():
	_update_health_bar()

remote func _set_pos(position):
	global_transform.origin = position


func _physics_process(_delta):
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0


	if Input.is_action_pressed("ui_up"):
		velocity.y -= FLY
		time = time+1
	else:
		time=0
		if Input.is_action_pressed("ui_select") and is_on_floor():
			velocity.y = -JUMP
		velocity.y += GRAVITY
		
	if (time > 45):
		FLY = -2
	else:
		FLY=10
		
	
	if is_network_master():
		$Camera2D.current = true
		velocity = move_and_slide(velocity, FLOOR)
		rpc_unreliable("_set_pos", global_transform.origin)
		animate()



sync func animate():
	
	var anim = "idle"

	if velocity.y > 0 and not $RayCast2D.is_colliding():
		anim = "fall"
		if velocity.x > 0:
			$Body/Sprite.flip_h = false
		elif velocity.x != 0:
			$Body/Sprite.flip_h = true
	elif velocity.y < 0 and not $RayCast2D.is_colliding():
		anim = "jump"
		if velocity.x > 0:
			$Body/Sprite.flip_h = false
		elif velocity.x != 0:
			$Body/Sprite.flip_h = true
	elif velocity.y == 0 and Input.is_action_pressed("ui_up"):
		anim = "press_up"
		if velocity.x > 0:
			$Body/Sprite.flip_h = false
		elif velocity.x != 0:
			$Body/Sprite.flip_h = true
	else:
		if velocity.x != 0:
			anim = "run"
			if velocity.x > 0:
				$Body/Sprite.flip_h = false
			else:
				$Body/Sprite.flip_h = true
	if $Body/Sprite.animation != anim:
		$Body/Sprite.play(anim)



onready var GunPos: = $Body/GunPosition
var gun_data: = {
	normal = preload("res://guns/Gun.tscn"),
	snipe = preload("res://guns/SnipeGun.tscn")
}
func equip_gun(gun_type:String):
	if is_network_master():
		for gun in GunPos.get_children():	#if there is gun remove it
			gun.queue_free()
		
		var gun:Sprite = gun_data[gun_type].instance()
		GunPos.add_child(gun)

#yes?
func gun_flip():
	for gun in GunPos.get_children():
		if gun.flip_v == true:
			$Body/Sprite.flip_h = true
		else:
			$Body/Sprite.flip_h = false

func _update_health_bar():
	$GUI/HealthBar.value = health_points			


func damage(value):
	health_points -= value
	if health_points <= 0:
		health_points = 0
	_update_health_bar()


	# func track_time_button():
# 	var button_time = 2
# 	if Input.is_action_just_pressed("ui_up"):
# 		$Timer.start(button_time)
# 	elif Input.is_action_just_released("ui_up"):
# 		$Timer.stop()
# 		if success:
# 			success = false
# 		else:
# 			print('fail')


# func _on_Timer_timeout():
# 	print("success")
# 	success = true
