extends Node2D

@onready var ray = $ShapeCast2D
@export var isSelected = true
@export var selectionId = 1
@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")
@onready var parent = self.get_parent()

var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 20
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if isSelected:
		if !moving:
			for dir in inputs.keys():
				if event.is_action_pressed(dir):
						move(dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func move(dir):
	ray.target_position = inputs[dir] * 128
	ray.force_shapecast_update()
	if !ray.is_colliding():
		parent.position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(parent, "position",
		parent.position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
		moving = true
		await tween.finished
		moving = false
	else:
		return
