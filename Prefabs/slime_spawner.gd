extends Node2D

signal characterSelected(selectionId)


var slimePrefabs = [
	preload("res://Prefabs/PlayableCharacterMinion.tscn")
	
	
	
	
	
]
var tile_size = 16
@onready var ray = get_tree().get_first_node_in_group("raycastLich")
@onready var tileMap = get_tree().get_first_node_in_group("tileMap")
@onready var lich = get_parent()

var slimes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#HACK god forgive me for elif cycling inputs
func _unhandled_input(event):
	if event.is_action_pressed("slime_1"):
		characterSelected.emit(1)
	elif event.is_action_pressed("slime_2"):
		characterSelected.emit(2)
	elif event.is_action_pressed("slime_3"):
		characterSelected.emit(3)
	elif event.is_action_pressed("slime_4"):
		characterSelected.emit(4)
	if event.is_action_pressed("interact"):
		if lich.isSelected:
			spawn_slime(0,0,1)
		

# TODO implement selection id giving and piling
# HACK stop manually selecting first minion
func spawn_slime(type,modifiers,selection_id):
	ray.force_shapecast_update()
	if !ray.is_colliding():
		var newSlime = slimePrefabs[type].instantiate()
		tileMap.add_child(newSlime)
		newSlime.global_position = ray.global_position + ray.get_target_position()/4
		#newSlime.selectionId = selection_id
