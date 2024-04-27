extends Node2D

@onready var signal_bus = get_node("/root/SignalBus")
@onready var lich = get_parent()
@export var selectedId = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.characterSwap.connect(slimeSwap)
	signal_bus.characterSelected.connect(_on_character_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func slimeSwap():
	var swapSlimeId = "Id_" + str(selectedId)
	if get_tree().get_first_node_in_group(swapSlimeId) != lich:
		var swapSlime = get_tree().get_first_node_in_group(swapSlimeId)
		var swapSlimePos1 = swapSlime.position
		var lichPos1 = lich.position
		lich.position = swapSlimePos1
		swapSlime.position = lichPos1
		#todo maybe tween this

func _on_character_selected(Id):
	selectedId = Id
