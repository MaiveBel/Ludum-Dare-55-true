extends Area2D

# todo - make positional save system
# todo - animation player for entities
# next - make slime abilities module
# next - make movable obj <<<<<<
# todo - add character deletion


@onready var ray = $ShapeCast2D
@export var isSelected = true
@export var selectionId = 1
@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")
@export var moveModule:Node2D


var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 20
var moving = false

func _ready():
	#get_move_module()
	slimeSpawner.characterSelected.connect(selectionCheck)

func _unhandled_input(event):
	if isSelected:
		if !moving:
			for dir in inputs.keys():
				if event.is_action_pressed(dir):
						moveModule.move(dir)

# bug 2 of the same character cant move together when touching


func selectionCheck(num):
	if num == selectionId:
		isSelected = true
	else:
		isSelected = false

func get_move_module():
	for node in get_tree().get_nodes_in_group("moveModule"):
		if is_ancestor_of(node):
			moveModule = node
