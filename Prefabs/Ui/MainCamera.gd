extends Camera2D

@onready var slimeSpawner = get_tree().get_first_node_in_group("slimeSpawner")

# Called when the node enters the scene tree for the first time.
func _ready():
	slimeSpawner.characterSelected.connect(charSelect)
	#debug_print_tree(4,$".")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func charSelect(Id):
	var target = get_tree().get_first_node_in_group("Id_" + str(1))
	remove_child(self)
	target.add_child(self)

func debug_print_tree(depth, node):
	print ("%*s %s %s" % [depth * 2, "", node, node.name])
	for c in node.get_children():
		debug_print_tree(depth+1, c)
