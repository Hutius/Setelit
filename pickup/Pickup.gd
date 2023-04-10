extends Area2D

export (String) var gun_type = 'normal'


func _ready()->void:
	var _random_var = connect("body_entered", self, 'body_entered')



func body_entered(body:PhysicsBody2D)->void:
		if body:
			if body.has_method('equip_gun'):
				body.equip_gun(gun_type)
				#self.queue_free()
			