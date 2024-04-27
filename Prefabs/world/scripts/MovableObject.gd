extends Area2D

@export var moveModule:Node2D
@export var ray:Node2D
@export var boxDetectorRay:Node2D
@export var weight = 1
@export var baseStr = 1
@export var type = [0]
@export var dead = false
@export var animation_speed = 8
var moving = false


var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func move_object(dir,sticky = false):
	if move_check(dir):
		moveModule.move(dir,sticky)
		

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
	elif boxDetectorRay.is_colliding() && boxDetectorRay.get_collider(0).is_in_group("StickySlime"):
		return true
	else:
		return false

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	tile_map_collision(body, body_rid)


func tile_map_collision(body,body_rid):
	var current_tilemap = body
	
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	
	
	var tile_data = current_tilemap.get_cell_tile_data(2, collided_tile_coords)
	if tile_data:
		
		var terrain_mask = tile_data.get_custom_data("Danger")
		if !type.has(terrain_mask):
			die()

func die():
	dead = true
	var tween = create_tween()
	tween.tween_property(self, "scale",self.scale*1.15, 1.0/(animation_speed*0.75)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale",self.scale*0.25, 1.0/(animation_speed)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	queue_free()
