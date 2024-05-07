extends Node2D

@onready var signal_bus = get_node("/root/SignalBus")
@export var protoset: ItemProtoset
@export var Prototype_Id = "smoler"
@export var touched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * signal_bus.tile_size)
	#position += Vector2.ONE * signal_bus.tile_size/2
	get_prototype_image()
	signal_bus.pickedUpItem.connect(_on_item_picked_up)



func _on_area_entered(area):
	if !touched:
		signal_bus.pickUpItem.emit(Prototype_Id,self)
		touched = true
		
	print(touched)

func get_prototype_image():
	$ItemTexture.texture = load(protoset.get_prototype_property(Prototype_Id,"image"))

func _on_item_picked_up(item_Id,floor_item):
	if floor_item == self:
		queue_free()



func _on_area_exited(area):
	touched = false
