extends Node2D

@onready var signal_bus = get_node("/root/SignalBus")
@export var protoset: ItemProtoset
@export var Prototype_Id = "smoler"

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * signal_bus.tile_size)
	#position += Vector2.ONE * signal_bus.tile_size/2
	get_prototype_image()



func _on_area_entered(area):
	signal_bus.pickUpItem.emit(Prototype_Id)
	queue_free()

func get_prototype_image():
	$ItemTexture.texture = load(protoset.get_prototype_property(Prototype_Id,"image"))
