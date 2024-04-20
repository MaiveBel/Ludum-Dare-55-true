extends Area2D

@onready var signal_bus = get_node("/root/SignalBus")
@export var pressed = false

@export var id = 0

@export var tile_size = 16


@export_enum("One-Shot","On/Off","Hold") var mode: int

@export var pressParticles:Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	
	add_to_group("button_id_" + str(id))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func press_button(In_Out: bool):
	match mode:
		0:
			if pressed:
				pass
			else: pressed = true
				
		1:
			if In_Out == true:
				pressed = !pressed
		2:
			if In_Out: 
				pressed = true
			else:
				pressed = false
# todo maybe this should be done at the door instead


func _on_area_entered(area):
	press_button(true)
	signal_bus.button_pressed.emit(true,id)


func _on_area_exited(area):
	press_button(false)
	signal_bus.button_pressed.emit(false,id)
