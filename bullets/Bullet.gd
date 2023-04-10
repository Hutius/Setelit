extends Area2D

export (float) var speed: = 10.0 * 100.0
export (float) var lifetime: = 2.0
export(float) var DAMAGE = 15

onready var timer: = $Timer
var velocity:Vector2
var spawner

func _ready()->void:
	timer.wait_time = lifetime
	timer.start()
	velocity = global_transform.x * speed
	set_as_toplevel(true)

	var _time = timer.connect("timeout", self, "timeout")
	var _random_var = connect("body_entered", self, 'body_entered')

# func _process(delta):
# 	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	
	

func _physics_process(_delta:float)->void:
	global_translate(velocity*_delta)
	

func body_entered(_body:StaticBody2D)->void:
	# if _body.is_a_parent_of(self):
	# 	return
	# if not _body.is_in_group('players'):
	# 	return
	# _body.damage(DAMAGE)
	queue_free()

func timeout()->void:
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


