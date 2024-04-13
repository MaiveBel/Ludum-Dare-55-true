extends Area2D

@onready var ray = $ShapeCast2D


var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 20
var moving = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
				move(dir)

func move(dir):
	ray.target_position = inputs[dir] * 116
	ray.force_shapecast_update()
	if !ray.is_colliding():
		position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",
		position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
		moving = true
		await tween.finished
		moving = false
	else:
		return

