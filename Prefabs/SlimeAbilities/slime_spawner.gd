extends Node2D

signal characterSelected(selectionId)


var slimePrefabs = [
	preload("res://Prefabs/PlayableCharacterMinion.tscn")
	
	
	
	
	
]
var tile_size = 16
@onready var ray = get_tree().get_first_node_in_group("raycastLich")
@onready var tileMap = get_tree().get_first_node_in_group("tileMap")
@onready var inventory_grid = get_tree().get_first_node_in_group("InventoryGrid")
@onready var lich = get_parent()

var slimes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_grid.spawn_slime_from_item_signal.connect(spawn_slime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#HACK god forgive me for elif cycling inputs
func _unhandled_input(event):
	if event.is_action_pressed("slime_1") && get_tree().get_first_node_in_group("Id_1"):
		characterSelected.emit(1)
		get_tree().get_first_node_in_group("Cam_Id_1").make_current()
	elif event.is_action_pressed("slime_2") && get_tree().get_first_node_in_group("Id_2"):
		characterSelected.emit(2)
		get_tree().get_first_node_in_group("Cam_Id_2").make_current()
	elif event.is_action_pressed("slime_3") && get_tree().get_first_node_in_group("Id_3"):
		characterSelected.emit(3)
		get_tree().get_first_node_in_group("Cam_Id_3").make_current()
	elif event.is_action_pressed("slime_4") && get_tree().get_first_node_in_group("Id_4"):
		characterSelected.emit(4)
		get_tree().get_first_node_in_group("Cam_Id_4").make_current()
	if event.is_action_pressed("interact"):
		if lich.isSelected:
			spawn_slime(0,0,1)
		

# TODO implement selection id giving and piling
# HACK stop manually selecting first minion
func spawn_slime(type : int,modifiers : int,selection_id : int):
	ray.force_shapecast_update()
	if !ray.is_colliding() && !lich.moving:
		var newSlime = slimePrefabs[type].instantiate()
		tileMap.add_child(newSlime)
		newSlime.global_position = ray.global_position + ray.get_target_position()/4
		newSlime.characterDied.connect(dead_character)
		slimes.append(newSlime)
		#newSlime.selectionId = selection_id

func dead_character(id,entity):
	characterSelected.emit(1)
	slimes.erase(entity)
