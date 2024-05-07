extends Node2D
@onready var level_loader = $ProjectLevelLoader
@onready var signal_bus = get_node("/root/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	level_loader.level_loaded.connect(_on_level_loaded)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_loaded():
	await level_loader.current_level.ready
	
