extends Control

const info_offset: Vector2 = Vector2(20, 0)

@export var ctrl_inventory_left  = CtrlInventoryGridEx
@export var inventory_grid = Node2D
@export var combine_button = Button

#@onready var ctrl_slot: CtrlItemSlot = $"%CtrlItemSlot"
@onready var lbl_info: Label = %LblInfo
#@onready var slimeSpawner = $/root/test/TileMap/PlayerArea/SlimeSpawner
# Hack this will mess up on scene switch

signal spawn_slime_from_item_signal(type : int,modifiers : int,selection_id : int)

func _ready() -> void:
	lbl_info.hide()
	ctrl_inventory_left.item_mouse_entered.connect(_on_item_mouse_entered)
	ctrl_inventory_left.item_mouse_exited.connect(_on_item_mouse_exited)
	ctrl_inventory_left.inventory_item_activated.connect(spawn_slime_from_item)
	#combine_button.pressed.connect(_on_combine_button_pressed)
	#slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")



func _on_item_mouse_entered(item: InventoryItem) -> void:
	lbl_info.show()
	lbl_info.text = item.prototype_id


func _on_item_mouse_exited(_item: InventoryItem) -> void:
	lbl_info.hide()


func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion):
		return

func _on_combine_button_pressed():
	combine_all_items()

#hack doesnt move the spawning spot
func combine_all_items():
	var items = inventory_grid.get_items()
	for item in items:
		if item.get_property("combines_with") != null:
			var combines_with = item.get_property("combines_with")
			if inventory_grid.has_item_by_id(combines_with):
				var items_combines_with = inventory_grid.get_items_by_id(combines_with)
				for o in items_combines_with:
					var item_combines_with = o
					var item_distance_final = item_distance_get(item,item_combines_with)
					if item_distance_final.x <= 1 and item_distance_final.y <= 1:
						if item.get_property("makes") != null:
							if inventory_grid.create_and_add_item_at(item.get_property("makes"),Vector2i(0,0)):
								inventory_grid.create_and_add_item_at(item.get_property("makes"),Vector2i(0,0))
								inventory_grid.remove_item(item)
								inventory_grid.remove_item(item_combines_with)
								print(item_distance_final)
					else:
						continue

func item_distance_get(item_1: InventoryItem,item_2: InventoryItem):
	var item_2_pos = inventory_grid.get_item_position(item_2)
	var item_2_size = inventory_grid.get_item_size(item_2)
	var item_1_pos = inventory_grid.get_item_position(item_1)
	var item_1_size = inventory_grid.get_item_size(item_1)
	var item_distance_x = item_1_pos.x - item_2_pos.x
	if item_distance_x < 1:
			item_distance_x = abs(item_1_pos.x - item_2_pos.x) - (item_1_size.x -1 )
	else:
			item_distance_x = abs(item_1_pos.x - item_2_pos.x) - (item_2_size.x -1 )
	var item_distance_y = item_1_pos.y - item_2_pos.y
	if item_distance_y < 1:
		item_distance_y = abs(item_1_pos.y - item_2_pos.y) - (item_1_size.y -1 )
	else:
		item_distance_y = abs(item_1_pos.y - item_2_pos.y) - (item_2_size.y -1 )
	var item_distance = Vector2i(item_distance_x,item_distance_y)
	print(str(item_distance) + " " + str(item_1_size) + " " + str(item_2_size))
	return item_distance

#todo add sound for crafting
func _on_inventory_item_activated(item: InventoryItem):
	if item.get_property("spawn") != null:
		spawn_slime_from_item(item)

func spawn_slime_from_item(item: InventoryItem):
	var spawn_info = item.get_property("spawn")
	spawn_slime_from_item_signal.emit(spawn_info[0],spawn_info[1],spawn_info[2])

