extends Node2D

@onready var parent = self.get_parent()
@onready var moveModule = get_node(str(parent.get_path())+ "/MoveModule")

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.add_to_group("EarthSlime")
	print(parent.get_groups())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
