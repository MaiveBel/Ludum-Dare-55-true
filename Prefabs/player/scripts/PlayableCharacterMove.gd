extends Area2D


# todo - animation player for entities

# todo - make levels
# todo - make lightable torches

# next - add audio
# next - add earth module
# todo - make visuals


@onready var signal_bus = get_node("/root/SignalBus")
@onready var player_cam = $PlayerCam
@onready var ray = $ShapeCast2D
@export var isSelected = true
@export var selectionId = 1
@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")
@export var moveModule:Node2D
#type 0 nothing, 1 fire,2 earth,3 water, 4 sticky
@export var type = [0]
@export var dead = false




var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@export var animation_speed = 8
var moving = false

func _ready():
	signal_bus.characterSelected.connect(selectionCheck)
	signal_bus.id_change.connect(on_id_change)
	Engine.time_scale = 1.0

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
		if terrain_mask != null:
			if  !type.has(terrain_mask):
				die()
		

func die():
	dead = true
	
	var tween = create_tween()
	signal_bus.characterDied.emit(selectionId,self)
	tween.tween_property(self, "scale",self.scale*1.15, 1.0/(animation_speed*0.75)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale",self.scale*0.25, 1.0/(animation_speed)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	
	queue_free()

func on_id_change(new_id,old_id):
	if old_id == selectionId:
		remove_from_group("Id_" + str(old_id))
		player_cam.remove_from_group("Cam_Id_" + str(old_id))
		add_to_group("Id_" + str(new_id))
		player_cam.add_to_group("Cam_Id_" + str(new_id))
	elif old_id == 0:
		add_to_group("Id_" + str(selectionId))
		player_cam.add_to_group("Cam_Id_" + str(selectionId))
