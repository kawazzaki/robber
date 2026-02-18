extends StaticBody3D



class_name Room




@export var room_size : Vector2
@export var can_rotate : bool
@export var links : Node

var doors = []

func clear():
	doors.clear()

func build():
	set_doors_direction()
	get_door_by_dir(Vector3.RIGHT)



func set_doors_direction():
	for l : Node3D in links.get_children():
		var door_forward = -l.global_transform.basis.z.normalized()
		doors.append({
			"obj":l,
			"dir":door_forward,
			"to_center":self.global_position - l.global_position
		})

func get_door_by_dir(dir : Vector3):
	for door in doors:
		if dir.is_equal_approx(door["dir"]):
			print('find door')
			return door
	print('cant find door')
	return null



func _ready() -> void:
	DebugConsole.add_command("br",build,self)



func _process(delta: float) -> void:
	if doors.is_empty():return
	for door in doors:
		DebugDraw3D.draw_arrow(door["obj"].global_position,door["obj"].global_position + door["dir"]*0.7, Color.BLUE,0.1)
