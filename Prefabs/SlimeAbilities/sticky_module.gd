extends Node2D
@onready var signal_bus = get_node("/root/SignalBus")

@onready var parent = self.get_parent()
@onready var moveModule = get_node(str(parent.get_path())+ "/MoveModule")
@onready var shape_cast_array = [$ShapeCastUp,$ShapeCastDown,$ShapeCastLeft,$ShapeCastRight]

#todo add area showing

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.add_to_group("StickySlime")
	print(parent.get_groups())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_box(dir,vectorDir):
	for ray in shape_cast_array:
		
		ray.force_shapecast_update()
		if (ray.target_position) != vectorDir*160:
			if ray.is_colliding():
				var object = ray.get_collider(0)
				if ray.get_collider(0).is_in_group("movableObject"):
					if object.weight <= moveModule.strength && object.move_check(dir) != false:
						object.add_strength(moveModule.strength)
						object.move_object(dir,true)
						if object != null:
							object.reset_strength()
