extends Area2D

@onready var signal_bus = get_node("/root/SignalBus")
@export var open = false

@export var id = 0

@export var tile_size = 16


@export_enum("One-Shot","On/Off","Hold") var mode: int

@export var pressParticles:Node2D
@onready var collision_shape_2d = $CollisionShape2D

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	
	add_to_group("door_id_" + str(id))
	
	signal_bus.button_pressed.connect(_on_button_pressed)

	


func _on_button_pressed(press,button_id):
	if button_id == id:
		match mode:
			0:
				if open:
					pass
				else: open = true
				
			1:
				if press == true:
					open = !open
			2:
				if press == true: 
					open = press
				else:
					open = press
		collision_shape_2d.set_deferred("disabled",open)
