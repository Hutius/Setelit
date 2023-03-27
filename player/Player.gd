extends KinematicBody2D


var velocity = Vector2()
const SPEED = 250
const GRAVITY = 15
const FLY = 10
const JUMP = 500
const FLOOR = Vector2(0, -1)

func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0


	if Input.is_action_pressed("ui_up"):
		velocity.y -= FLY
	else:
		if Input.is_action_pressed("ui_select") and is_on_floor():
			velocity.y = -JUMP
		velocity.y += GRAVITY
	

	velocity = move_and_slide(velocity, FLOOR)
	animate()
	#gun_flip()

func animate():
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
