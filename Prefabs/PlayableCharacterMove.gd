extends Area2D

# todo - make positional save system
# todo - animation player for entities
# next - make slime abilities module
# todo - add character deletion
# todo - make levels
# todo - make lightable torches
# todo - make scene manager


@onready var ray = $ShapeCast2D
@export var isSelected = true
@export var selectionId = 1
@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")
@export var moveModule:Node2D
@export var type = 0
@export var dead = false

signal characterDied(selectionId)

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var animation_speed = 20
var moving = false

func _ready():
	slimeSpawner.characterSelected.connect(selectionCheck)

func _unhandled_input(event):
	if isSelected:
		for dir in inputs.keys():
			if event.is_action_pressed(dir):
				if !moving:
					moveModule.move(dir)



func selectionCheck(num):
	if num == selectionId:
		isSelected = true
	else:
		isSelected = false



func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	tile_map_collision(body, body_rid)


func tile_map_collision(body,body_rid):
	var current_tilemap = body
	
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	
	
	var tile_data = current_tilemap.get_cell_tile_data(2, collided_tile_coords)
	if tile_data:
		
		var terrain_mask = tile_data.get_custom_data("Danger")
		if terrain_mask != type:
			die()

func die():
	dead = true
	characterDied.emit(selectionId)
