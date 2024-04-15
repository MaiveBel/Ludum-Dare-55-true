extends Node2D

@export var ray:Node2D
@onready var parent = self.get_parent()
@export var pushableTarget = false
@export var strength = 0

@export var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 20
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.position = parent.position.snapped(Vector2.ONE * tile_size)
	parent.position += Vector2.ONE * tile_size


func move(dir):
	ray.target_position = inputs[dir] * 128
	ray.force_shapecast_update()
	
	if !ray.is_colliding() && !moving:
		parent.position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(parent, "position",
		parent.position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
		moving = true
		parent.moving = true
		await tween.finished
		moving = false
		parent.moving = false
	
	elif !moving && ray.get_collider(0)!= null && ray.get_collider(0).is_in_group("movableObject"):
		var object = ray.get_collider(0)
		if object.weight <= strength && object.move_object(dir) != false:
			object.add_strength(strength)
			object.move_object(dir)
			parent.position += inputs[dir] * tile_size
			var tween = create_tween()
			tween.tween_property(parent, "position",
			parent.position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
			moving = true
			parent.moving = true
			await tween.finished
			moving = false
			parent.moving = false
			object.reset_strength()
		else:
			return
	else:
		return
		
		




#todo make weights chain togetherd
#bug moving inside boxes
