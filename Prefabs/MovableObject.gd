extends Area2D

@export var moveModule:Node2D
@export var ray:Node2D
@export var boxDetectorRay:Node2D
@export var weight = 1
@export var baseStr = 1
var moving = false


var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func move_object(dir):
	if move_check(dir):
		moveModule.move(dir)
		

func add_strength(str):
	moveModule.strength = str
	
func reset_strength():
	moveModule.strength = baseStr
#opt no need to retrigger ray
func move_check(dir):
	boxDetectorRay.target_position = inputs[dir] * 16*10
	boxDetectorRay.force_shapecast_update()
	if !boxDetectorRay.is_colliding():
		return true
	elif boxDetectorRay.is_colliding() && boxDetectorRay.get_collider(0).is_in_group("movableObject"):
		if boxDetectorRay.get_collider(0).move_check(dir) != false:
			return true
		else:
			return false
	else:
		return false

