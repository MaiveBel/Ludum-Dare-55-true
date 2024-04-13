extends Control

const info_offset: Vector2 = Vector2(20, 0)

@onready var ctrl_inventory_left := $"%CtrlInventoryGridLeft"

@onready var ctrl_slot: CtrlItemSlot = $"%CtrlItemSlot"
@onready var lbl_info: Label = $"%LblInfo"


func _ready() -> void:
	ctrl_inventory_left.item_mouse_entered.connect(_on_item_mouse_entered)
	ctrl_inventory_left.item_mouse_exited.connect(_on_item_mouse_exited)



func _on_item_mouse_entered(item: InventoryItem) -> void:
	lbl_info.show()
	lbl_info.text = item.prototype_id


func _on_item_mouse_exited(_item: InventoryItem) -> void:
	lbl_info.hide()


func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion):
		return

