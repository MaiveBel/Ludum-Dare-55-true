extends Area2D

# todo - make positional save system
# todo - animation player for entities
# next - make slime abilities module
# next - make movable obj

@onready var ray = $ShapeCast2D
@export var isSelected = true
@export var selectionId = 1
@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")

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
	slimeSpawner.characterSelected.connect(selectionCheck)

func _unhandled_input(event):
	if isSelected:
		if !moving:
			for dir in inputs.keys():
				if event.is_action_pressed(dir):
						move(dir)

# bug 2 of the same character cant move together when touching
func move(dir):
	ray.target_position = inputs[dir] * 128
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

func selectionCheck(num):
	if num == selectionId:
		isSelected = true
	else:
		isSelected = false
