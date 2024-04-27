extends Area2D

@onready var signal_bus = get_node("/root/SignalBus")
@export var open = false

@export var nextId = 0

@export var tile_size = 16

@export var pressParticles:Node2D
@onready var collision_shape_2d = $CollisionShape2D

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	
	
	#signal_bus.button_pressed.connect(_on_button_pressed)

	

func _on_area_entered(area):
	if area.is_in_group("lich"):
		print("next")
		enter_next_level()

#todo add level transitions
func enter_next_level():
	signal_bus.nextLevel.emit(nextId)
