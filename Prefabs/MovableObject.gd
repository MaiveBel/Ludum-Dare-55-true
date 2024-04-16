extends Area2D

@export var moveModule:Node2D
@export var ray:Node2D
@export var weight = 1
@export var baseStr = 1
var moving = false


var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func move_object(dir):
	ray.target_position = inputs[dir] * 128
	ray.force_shapecast_update()
	if ray.get_collider(0)== null:
		moveModule.move(dir)
	if ray.get_collider(0)!= null && ray.get_collider(0).is_in_group("movableObject"):
		if ray.get_collider(0).move_object(dir) != false:
			moveModule.move(dir)
		else:
			return false
	else:
		return false

func add_strength(str):
	moveModule.strength = str
	
func reset_strength():
	moveModule.strength = baseStr
#opt no need to retrigger ray
