extends Control

const info_offset: Vector2 = Vector2(20, 0)
@onready var signal_bus = get_node("/root/SignalBus")

@export var ctrl_inventory_left  = Node2D
@export var inventory_grid = Node2D
@export var combine_button = Button

#@onready var ctrl_slot: CtrlItemSlot = $"%CtrlItemSlot"
@onready var lbl_info: Label = %LblInfo
#@onready var slimeSpawner = $/root/test/TileMap/PlayerArea/SlimeSpawner
# Hack this will mess up on scene switch


func _ready() -> void:
	lbl_info.hide()
	ctrl_inventory_left.item_mouse_entered.connect(_on_item_mouse_entered)
	ctrl_inventory_left.item_mouse_exited.connect(_on_item_mouse_exited)
	ctrl_inventory_left.inventory_item_activated.connect(_on_inventory_item_activated)
	signal_bus.pickUpItem.connect(pick_up_item)
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
	var selected_items = ctrl_inventory_left.get_selected_inventory_items()
	for item in items:
		if item.get_property("combines_with") != null && selected_items.has(item) or item.get_property("combines_with") != null && selected_items.is_empty():
			var combines_with = item.get_property("combines_with")
			if inventory_grid.has_item_by_id(combines_with):
				var items_combines_with = inventory_grid.get_items_by_id(combines_with)
				for o in items_combines_with:
					var item_combines_with = o
					var item_distance_final = item_distance_get(item,item_combines_with)
					if item_distance_final.x <= 1 and item_distance_final.y <= 1:
						if item.get_property("makes") != null && selected_items.has(item_combines_with) or item.get_property("makes") != null && selected_items.is_empty():
							var new_item = inventory_grid.create_and_add_item(item.get_property("makes"))
							inventory_grid.remove_item(new_item)
							if inventory_grid.find_free_place(new_item).success:
								item.set_property("makes",null)
								print(item.get_property("makes"))
								inventory_grid.add_item_at(new_item,inventory_grid.find_free_place(new_item).position)
								print(item.get_property("id"))
								inventory_grid.remove_item(item)
								print(item_combines_with.get_property("id"))
								inventory_grid.remove_item(item_combines_with)
								print(item_distance_final)
							else:
								new_item.queue_free
								
					
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
	#print(str(item_distance) + " " + str(item_1_size) + " " + str(item_2_size))
	return item_distance

#todo add sound for crafting
func _on_inventory_item_activated(item: InventoryItem):
	if item.get_property("swap") != null:
		
		swap_slime_from_item(item)
	if item.get_property("spawn") != null:
		spawn_slime_from_item(item)

func spawn_slime_from_item(item: InventoryItem):
	var spawn_info = item.get_property("spawn")
	
	signal_bus.spawn_slime_from_item_signal.emit(spawn_info[0],spawn_info[1],spawn_info[2])

func swap_slime_from_item(item: InventoryItem):
	print(item.get_property("swap"))
	signal_bus.characterSwap.emit()

func pick_up_item(Id: String):
	var new_item = inventory_grid.create_and_add_item(Id)
	if inventory_grid.find_free_place(new_item).success:
		inventory_grid.add_item_at(new_item,inventory_grid.find_free_place(new_item).position)
	else:
		new_item.queue_free
